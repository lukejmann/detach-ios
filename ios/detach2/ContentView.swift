import CoreMotion
import NetworkExtension
import SwiftUI

var connectingProxyPingCount = 0

struct ContentView: View {
    @State public var cScreen: String = "HomeMenu"
    @State var showLoginScreen = getUserID() == nil
    @State var showSetDuration = false
//    @State var durationString: String = String(format: "%02d", getSessionDuration() / (60 * 60)) + ":" + String(format: "%02d", (getSessionDuration() % 3600) / 60)
    @State var sessionEndDate: Date? = nil
    @State var proxyStatus: NEVPNStatus = .invalid
    @State var selectAppsSwipeState: CGSize = CGSize.zero

    @ObservedObject var manager = MotionManager()

    func startFocusPressed() {
        let sessionDuration = getSessionDuration()
        let now = Date()
        sessionEndDate = now + Double(sessionDuration)
        setSessionEndDate(date: sessionEndDate!)
        startSession(endTime: sessionEndDate!) { success in
            self.cScreen = "Start"
            if success {
                TunnelController.shared.setEnabled(true){ error in
                    if error != nil {
                        print("[SESSION][ERROR] error enabling proxy. error: \(error)")
                    }
                    else {
                        print("[SESSION] successfully enabled proxy")
                    }
                }
            } else {
                // TODO: handle err
                print("[SESSION] error starting session")
            }
        }
    }

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    
    func onAppear() {
        print("[SCREEN_CONTENTVIEW] onAppear called")
//        if Date() > getSessionEndDate() ?? Date().addingTimeInterval(.infinity) {
//            TunnelController.shared.disable()
//            cScreen = "HomeMenu"
//        }
        if let sessionEndDate = getSessionEndDate() {
            self.sessionEndDate = sessionEndDate
            if Date() <= sessionEndDate {
                cScreen = "Start"
            }
        }
        refreshSupportedApps()
    }


    /* attempt bug where after starting session VPN status stays on "Connecting" or "Disconnected" despite returning no connection error
     i'm going to try just showing 'connected' because I suspect the status simply is not updating because a lack of requests?
     */
//    let connectingProxyRestartThreshold = 15
//     func connectingProxyCheckIn() {
//        let status = TunnelController.shared.status()
//        if getSessionEndDate() != nil {
//            if status == .disconnected || status == .connecting {
//                connectingProxyPingCount += 1
//                print("connectingProxyPingCount: \(connectingProxyPingCount)")
//                if connectingProxyPingCount % connectingProxyRestartThreshold == 0 {
//                    sendProxyTestConnection {
//                        let newStatus = TunnelController.shared.status()
//                        if TunnelController.shared.status() == .connected {
//                            print("[SESSION][TUNNEL_CONTROLLER] ping to update connection successful")
//                            connectingProxyPingCount = 0
//                        }
//                    }
//                }
//            } else {
//                connectingProxyPingCount = 0
//            }
//        } else {
//            connectingProxyPingCount = 0
//        }
//    }

   

    var body: some View {
        GeometryReader { geo in
            if showLoginScreen {
                LoginScreen {
                    // log in completed
                    self.showLoginScreen = false
                }
//                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 12))
            } else {
                ZStack {
                    VStack {
                        VStack {
                            HStack {
                                if self.cScreen == "SelectApps" { Button(action: {
                                    self.cScreen = "HomeMenu"
                                }) {
                                        Image("leftArrow").resizable().frame(width: 44, height: 21, alignment: .leading).padding(.leading, s.universal.horizontalPadding).animation(.easeOut(duration: 0.5)).offset(x: self.selectAppsSwipeState.width).opacity((100.0 - Double(self.selectAppsSwipeState.width)) / 100)
                                }
//                                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 12))
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
//                        .modifier(ParallaxMotionModifier(manager: manager, magnitude: 12))
                    }
                    //                    SetDurationOverlay(durationString: self.$durationString, setDurationString: { str in
                    //                        self.durationString = str
                    //                    }, keyboardVisible: self.$keyboardVisible) {
                    //                            self.hideDurationOverlay()
                    //                    }.offset(y: self.showSetDuration ? 0 : (geo.size.height + 40)).animation(.easeInOut(duration: 0.45))
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center).ignoresSafeArea(.keyboard)
            }
        }
        .onAppear {
            self.onAppear()
        }.onReceive(timer, perform: { _ in
            self.connectingProxyCheckIn()
        }).background(Image("bg-grain").resizable().edgesIgnoringSafeArea([.top, .bottom]))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
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
