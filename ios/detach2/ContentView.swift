







import NetworkExtension
import SwiftUI

struct ContentView: View {
    @State public var cScreen: String = "HomeMenu"
    @State var showLoginScreen = getUserID() == "N/A userID"
    @State var hasDetachPlus = true
    @State var showSetDuration = false
    @State var keyboardVisible: Bool = false
    @State var durationString: String = String(format: "%02d", getSessionDuration() / (60 * 60)) + ":" + String(format: "%02d", (getSessionDuration() % 3600) / 60)
    @State var sessionEndDate: Date? = nil
    @State var proxyStatus: NEVPNStatus = .invalid

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
        keyboardVisible = false
    }

    func proxyCheckIn() {
        if let sessionEndDate = getSessionEndDate() {
            if Date() > sessionEndDate {
                TunnelController.shared.disable()
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    if self.cScreen == "SelectApps" { Button(action: {
                        self.cScreen = "HomeMenu"
                    }) {
                            Image("leftArrow").resizable().frame(width: 44, height: 21, alignment: .leading)
                    }}
                    Spacer()
                    StatusIndicator(timer: self.timer, proxyStatus: self.$proxyStatus, cScreen: self.$cScreen).frame(width: 203, height: 33, alignment: .trailing).padding(.trailing, 30)
                }.frame(width: geo.size.width, height: 33, alignment: .center).padding(.top, 30)
                ZStack(alignment: .center) {

                    HomeMenu(durationString: self.$durationString) { screen in
                        self.cScreen = screen
                    } startFocusPressed: {
                        self.startFocusPressed()
                    } showDurationScreen: {
                        self.showDurationOverlay()
                    }.offset(x: self.cScreen != "HomeMenu" ? -1 * geo.size.width : 0).animation(.spring())
                    SelectAppsScreen { screen in
                        self.cScreen = screen
                    }

                    .offset(x: self.cScreen == "SelectApps" ? 0 : geo.size.width, y: 0).animation(.spring())
                    SessionScreen(endDate: self.$sessionEndDate) { screen in
                        self.cScreen = screen
                    }.offset(x: self.cScreen == "Start" ? 0 : geo.size.width, y: 0).animation(.spring())
                }.padding(.horizontal, 30)

            }
            SetDurationOverlay(durationString: self.$durationString, setDurationString: { str in
                self.durationString = str
            }, keyboardVisible: self.$keyboardVisible) {
                    self.hideDurationOverlay()
            }.offset(y: self.showSetDuration ? 0 : (geo.size.height + 40)).animation(.easeInOut(duration: 0.45))



















        }.background(Image("bg-grain")).ignoresSafeArea(.keyboard)
            .onAppear {
                self.onAppear()
            }.onReceive(timer, perform: { _ in
                self.proxyCheckIn()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
