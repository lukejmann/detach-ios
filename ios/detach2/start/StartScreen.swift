import Introspect
import SwiftUI

// TODO: remove success stage of button

struct StartScreen: View {
    var setScreen: (_ screen: String) -> Void
    @State var sliderPercent: Float = 20
    @State var startMode: StartMode = .disabled

    @State var sliderDistance: CGFloat = 0
//    @State var sliderIsLocked: Bool = false

    @State var showProxyAlert: Bool = false

    @State var durationString: String = "00:00"

    @State var keyboardVisible: Bool = true

    @Environment(\.colorScheme) var colorScheme

    func hideKeyboard() {
        UIApplication.shared.hideKeyboard()
        keyboardVisible = false
    }

    func showKeyboard() {
        keyboardVisible = true
    }

    init(setScreen: @escaping (_ screen: String) -> Void) {
        self.setScreen = setScreen
    }

    func proxyDeclined() {
        resetSlider()
    }

    func proxyAgreed() {
        resetSlider()
//        setVPNDomains(domains: ["instagram.com"])
        connectProxy(i: 0) { success in
            if success {
                self.startMode = .proxyEnabled
            } else {
                self.startMode = .proxyFailure
            }
        }
    }

    func beginSess() {
        print("begin sess called")
        let endTimeSec = calculateEndTimeSec(duration: durationString)
        uploadSession(endTimeUnix: endTimeSec) { success in
            if success {
                self.setScreen("Session")
            }
        }
    }

    func calculateEndTimeSec(duration: String) -> Int {
        // TODO: unwrap
        let hours = Int(duration[0] + duration[1])!
        let minutes = Int(duration[3] + duration[4])!
        let today = Date()
        let hoursAdded = Calendar.current.date(byAdding: .hour, value: hours, to: today)!
        let minutesAdded = Calendar.current.date(byAdding: .minute, value: minutes, to: hoursAdded)!
        return Int(minutesAdded.timeIntervalSince1970)
    }

    func resetSlider() {
        sliderDistance = 0
        keyboardVisible = true
    }

    func toggleShowAlert() {
        showProxyAlert.toggle()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Image(self.colorScheme == .dark ? "backDark" : "backLight").resizable().frame(width: 9, height: 17, alignment: .leading).onTapGesture {
                    self.setScreen("HomeMenu")
                }
                Text("begin blocking session").font(.custom("Georgia-Italic", size: 25)).padding(.top, 30)
                Text("SET HOW LONG THE SELECTED APPS WILL BE BLOCKED FOR").font(.system(size: 14, weight: .regular, design: .default)).padding(.top, 10)
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    CustomUIKitTextField(text: self.$durationString, startMode: self.$startMode, isFirstResponder: self.$keyboardVisible, resetSlider: self.resetSlider, placeholder: "00:00").padding(.top, 30.0)
                    Spacer()
                }
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Rectangle().fill(Color.gray).frame(width: 200, height: 1, alignment: .center)
                    Spacer()
                }.padding(.top, 8)
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("HOURS")
                    Spacer().frame(width: 31, height: 0, alignment: .center)
                    Text("MINUTES")
                    Spacer()
                }.padding(.top, 60)
                if self.startMode == .proxyEnabled {
                    SliderBar(proxyAlertIsShowing: self.$showProxyAlert, percentage: self.$sliderPercent, distance: self.$sliderDistance, mode: self.$startMode, showKeyboard: self.showKeyboard, hideKeyboard: self.hideKeyboard, thresholdReached: self.beginSess)
                } else {
                    SetupProxyButton(mode: self.$startMode, showProxyAlert: self.$showProxyAlert, proxyDeclined: self.proxyDeclined, proxyAgreed: self.proxyAgreed, hideKeyboard: self.hideKeyboard, toggleShowProxyAlert: self.toggleShowAlert)
                }

            }.padding(.top, 60).padding(.horizontal, 37)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .topLeading)
        }
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen { _ in
        }
    }
}

enum StartMode {
    case disabled
    case validInput
    case proxyEnabled
    case proxyFailure
//    case showSlider
}

extension StringProtocol {
    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
