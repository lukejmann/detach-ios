import Introspect
import SwiftUI

// TODO: remove success stage of button

struct StartScreen: View {
    var setScreen: (_ screen: String) -> Void
    @State var sliderPercent: Float = 20
    @State var startMode: StartMode = .disabled

    @State var sliderDistance: CGFloat = 0

    @State var durationString: String = "00:00"

    @State var keyboardVisible: Bool = true

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

    func connect(i: Int, callback: @escaping (_ success: Bool) -> Void) {
        let seconds = 1.0
        if i >= 4 {
            callback(false)
            return
        }
        TunnelController.shared.setEnabled(true) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                let status = TunnelController.shared.status()
                if status == .connected {
                    callback(true)
                    return
                } else {
                    self.connect(i: i + 1, callback: callback)
                }
            }
        }
    }

    func proxyDeclined() {
        resetSlider()
    }

    func proxyAgreed() {
        resetSlider()
        setBlockedDomains(domains: ["instagram.com"])
        connect(i: 0) { success in
            if success {
                self.startMode = .proxyEnabled
            } else {
                self.startMode = .proxyFailure
            }
        }
    }

    func startSession() {}

    func resetSlider() {
        sliderDistance = 0
        keyboardVisible = true
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Image("back").resizable().frame(width: 9, height: 17, alignment: .leading).onTapGesture {
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
                }.padding(.top, 8)
                if self.startMode == .proxyEnabled {
                    SliderBar(percentage: self.$sliderPercent, distance: self.$sliderDistance, mode: self.$startMode, showKeyboard: self.showKeyboard, hideKeyboard: self.hideKeyboard, thresholdReached: self.startSession)
                } else {
                    SetupProxyButton(mode: self.$startMode, proxyDeclined: self.proxyDeclined, proxyAgreed: self.proxyAgreed, hideKeyboard: self.hideKeyboard)
                }

            }.padding(.top, 40).padding(.horizontal, 37)
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
