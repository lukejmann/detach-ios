import CoreMotion
import NetworkExtension
import SwiftUI

struct ContentView: View {
    @State public var cScreen: String = "HomeMenu"
    @State var showLoginScreen = getUserID() == nil
    @State var hasDetachPlus = true
    @State var showSetDuration = false
    @State var keyboardVisible: Bool = false
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
        uploadSession(endTime: sessionEndDate!) { success in
            if success {
                self.cScreen = "Start"
                connectProxy(i: 0) { success in
                    if success {
                        //                         TODO: handle
                    } else {
                        //                         TODO: handle
                        print("Error!! unable to connect proxy")
                    }
                }
            } else {
                //                 TODO: handle err
                print("Error!! unable to start session")
            }
        }
    }

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    func onAppear() {
        print("in app appeared")
        if Date() > getSessionEndDate() ?? Date().addingTimeInterval(.infinity) {
            TunnelController.shared.disable()
            cScreen = "HomeMenu"
        }
        if let sessionEndDate = getSessionEndDate() {
            if Date() <= sessionEndDate {
                cScreen = "Start"
            }
        }
        refreshSupportedApps()
    }

    func showDurationOverlay() {
        showSetDuration = true
        print("calling self.keyboardVisible = true")
        keyboardVisible = true
    }

    func hideDurationOverlay() {
        showSetDuration = false
        print("calling self.keyboardVisible = false")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            keyboardVisible = false
        }
    }

    func proxyCheckIn() {
        if let sessionEndDate = getSessionEndDate() {
            if Date() > sessionEndDate && !(TunnelController.shared.status() == .disconnecting || TunnelController.shared.status() == .disconnected || TunnelController.shared.status() == .invalid) {
                TunnelController.shared.disable()
            }
        }
    }

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
                            HomeMenu(){ screen in
                                self.cScreen = screen
                            } startFocusPressed: {
                                self.startFocusPressed()
                            } showDurationScreen: {
                                self.showDurationOverlay()
                            }
                            .padding(.horizontal, s.universal.horizontalPadding)
                            .offset(x: self.cScreen != "HomeMenu" ? -1 * geo.size.width : 0).animation(.spring())
                            SelectAppsScreen(swipeState: self.$selectAppsSwipeState, setSwipeState: { state in
                                self.selectAppsSwipeState = state
                            }, setScreen: { screen in
                                self.cScreen = screen
                            }).offset(x: self.cScreen == "SelectApps" ? 0 : geo.size.width, y: 0).animation(.spring())
                            SessionScreen(endDate: self.$sessionEndDate) { screen in
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
            self.proxyCheckIn()
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
