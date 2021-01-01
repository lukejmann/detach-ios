import CoreMotion
import NetworkExtension
import SwiftUI

enum AlertType {
    case unableToStartSession, notifs
}

struct ContentView: View {
    @State public var cScreen: String = "HomeMenu"
    @State var showLoginScreen = getUserID() == nil
    @State var showSetDuration = false
    @State var sessionEndDate: Date? = nil
    @State var proxyStatus: NEVPNStatus = .invalid
    @State var selectAppsSwipeState: CGSize = CGSize.zero
    @State private var showAlert = false
    @State private var activeAlert: AlertType = .unableToStartSession


    @ObservedObject var manager = MotionManager()

    func startFocusPressed() {
        checkNotifSettings() { enabled in
            if enabled {
                let sessionDuration = getSessionDuration()
                let now = Date()
                sessionEndDate = now + Double(sessionDuration)
                startSession(endTime: sessionEndDate!) { success in
                    if success {
                        setSessionEndDate(date: sessionEndDate!)
                        self.cScreen = "Start"
                        TunnelController.shared.enable { (success) in
                            if !success{
                                print("[SESSION][ERROR] error enabling proxy. cancelling session")
                                cancelSession { (success) in
                                    if success {
                                        print("[SESSION] session cancelled")
                                    } else {
                                        print("[SESSION][ERROR] error cancelling session")
                                    }
                                }
                            } else {
                                print("[SESSION] successfully enabled proxy")
                                
                            }
                        }
                    } else {
                        print("[SESSION] error starting session")
                        self.activeAlert = .unableToStartSession
                        self.showAlert = true
                    }
                }

            } else {
                self.activeAlert = .notifs
                self.showAlert = true
            }
        }
        return
    }


    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    
    func onAppear() {
        print("[SCREEN_CONTENTVIEW] onAppear called")
        if let sessionEndDate = getSessionEndDate() {
            print("SESSION ENDDATE: \(sessionEndDate)")
            self.sessionEndDate = sessionEndDate
            if Date() <= sessionEndDate {
                cScreen = "Start"
            }
        }
        refreshSupportedApps()
    }



    var body: some View {
        GeometryReader { geo in
            ZStack{


            if showLoginScreen {
                LoginScreen {
                    // log in completed
                    self.showLoginScreen = false
                }
                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
            } else {
                ZStack {
                    VStack {
                        VStack {
                            HStack {
                                if self.cScreen == "SelectApps" { Button(action: {
                                    self.cScreen = "HomeMenu"
                                }) {
                                    Image("leftArrow").resizable().frame(width: 44, height: 21, alignment: .leading).padding(.leading, s.universal.horizontalPadding).animation(.easeOut(duration: 0.5)).opacity((100.0 - Double(self.selectAppsSwipeState.width)) / 100)
                                }
                                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
                                }
                                Spacer()
                                StatusIndicator(timer: self.timer, proxyStatus: self.$proxyStatus, cScreen: self.$cScreen).frame(width: 203, height: 33, alignment: .trailing)
                            }.frame(width: geo.size.width, height: 33, alignment: .center).padding(.top, s.universal.statusIndicatorToTop)
                        }
                        ZStack(alignment: .center) {
                            HomeMenu(currentScreen: self.$cScreen){ screen in
                                self.cScreen = screen
                            } startFocusPressed: {
                                self.startFocusPressed()
                            }
                            .padding(.horizontal, s.universal.horizontalPadding)
                            .offset(x: self.cScreen != "HomeMenu" ? -1 * geo.size.width : 0).animation(.spring())
                            SelectAppsScreen(swipeState: self.$selectAppsSwipeState, setSwipeState: { state in
                                self.selectAppsSwipeState = state
                            }, setScreen: { screen in
                                self.cScreen = screen
                            }).offset(x: self.cScreen == "SelectApps" ? 0 : geo.size.width, y: 0).animation(.spring())
                            SessionScreen(endDate: self.$sessionEndDate, timer: self.timer) { screen in
                                self.cScreen = screen
                            }.offset(x: self.cScreen == "Start" ? 0 : geo.size.width, y: 0).animation(.spring()).padding(.horizontal, s.universal.horizontalPadding)
                        }
                        .modifier(ParallaxMotionModifier(manager: manager, magnitude: 7))
                    }
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center).ignoresSafeArea(.keyboard)
            }
            }.onAppear(perform: {
                calculateSpacing(screenWidth: geo.size.width, screenHeight: geo.size.height)
            })
        }
        .alert(isPresented: $showAlert) {
                   switch activeAlert {
                   case .unableToStartSession:
                        return Alert(title: Text("Unable to start session"), message: Text("Please try again later."), dismissButton: .default(Text("Done")))
                   case .notifs:
                       return Alert(title: Text("Push Notifications Required"), message: Text("Detach requires push notifications to disable the DNS filter when sessions are completed. Please enable push notifications in settings." ), primaryButton: Alert.Button.default(Text("Open Settings"), action: {
                        print("OPEN SETTINGS PRESSED")

                        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                            if UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings)
                            }
                        }
                    }),
                    secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                        print("CANCEL PRESSED")
                    })
                    )
                   }
               }

        .onAppear {
            self.onAppear()
        }.background(Image("bg-grain").resizable().edgesIgnoringSafeArea([.top, .bottom]))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone XR"))
    }
}

struct ParallaxMotionModifier: ViewModifier {
    @ObservedObject var manager: MotionManager
    var magnitude: Double

    func body(content: Content) -> some View {
        content
            .offset(x: CGFloat(manager.roll * magnitude), y: CGFloat(manager.pitch * magnitude))
    }
}

class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0

    private var manager: CMMotionManager

    init() {
        manager = CMMotionManager()
        manager.deviceMotionUpdateInterval = 1 / 60
        manager.startDeviceMotionUpdates(to: .main) { motionData, error in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
            }
        }
    }
}


