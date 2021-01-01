import AuthenticationServices
import SwiftUI
enum loginPage {
    case descriptionOne
    case signIn
    case proxySetup
    case proxyError
}

struct LoginScreen: View {
    var loginCompleted: () -> Void
    @State var loginPage: loginPage = .descriptionOne
    @Environment(\.colorScheme) var colorScheme
    func setCredentials(creds: CredentialsOrError) {
        if creds.isSuccess {
            loginUser(userID: creds.values?.user ?? "", email: creds.values?.email ?? "") { success in
                if success {
                    print("[LOGIN][API] loginUser successful")
                    self.loginPage = .proxySetup
                } else {
                    print("[LOGIN][API][ERROR] loginUser failure")
                }
            }
        }
    }

    func setupProxy() {

//         calling enable() fails on login. can just call setEnable to setup once and then manage once in app.
                TunnelController.shared.setEnabled(true) { error in
                    if error != nil {
                        print("[LOGIN] successfully setup proxy")
                        TunnelController.shared.disable()
                        loginCompleted()
                    } else {
                        print("[LOGIN] error setting up proxy. error: \(String(describing: error))")
                        self.loginPage = .proxyError
                    }
                }


    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text("detach").font(.custom("Georgia-Italic", size: 42)).foregroundColor(Color.tan)
                }.frame(width: geo.size.width, height: .none, alignment: .center).padding(.top, 0.071 * geo.size.height)
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("We love the apps on our phones, but using our phones without getting distracted is a challenge.").font(.system(size: 25, weight: .semibold, design: .default)).kerning(-0.8).foregroundColor(Color.tan)
                        Text("Detach temorarily blocks chosen apps from your phone so you can stay focused on what matters.").font(.system(size: 25, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan).padding(.top, 30)
                        HStack {
                            Spacer()
                            Button(action: {
                                self.loginPage = .signIn
                            }) {
                                Image("rightArrow").resizable().frame(width: 52.25, height: 25, alignment: .center)
                            }
                        }.frame(width: geo.size.width - s.universal.horizontalPadding * 2).padding(.top, 40)
                    }.offset(x: self.loginPage == .descriptionOne ? 0 : -1.5 * geo.size.width).padding(.horizontal, 25)
                    VStack {
                        Text("Login or sign up to get started.").font(.system(size: 23, weight: .semibold, design: .default)).kerning(-0.5).foregroundColor(Color.tan).frame(width: 300, height: .none)
                            .onTapGesture {
                                if isBeingDebugged(){
                            self.loginPage = .proxySetup}
                        }
                        HStack {
                            Spacer()
                            SignInWithAppleButton(setCredentials: self.setCredentials).frame(width: 300, height: 44, alignment: .center).padding(.top, 30)
                            Spacer()
                        }
                    }.offset(x: self.loginPage == .signIn ? 0 : self.loginPage == .descriptionOne ? 1.5 * geo.size.width : -1.5 * geo.size.width)
                    VStack(alignment: .leading) {
                        Text("Last step! Detach blocks apps by preventing them from connecting to the internet using a DNS filter.").font(.system(size: 25, weight: .semibold, design: .default)).kerning(-1).foregroundColor(Color.tan)
                            .onTapGesture {
                                if isBeingDebugged(){
                                self.loginCompleted()}
                        }
                        Text("To proceed, setup the DNS filter.").kerning(-1).foregroundColor(Color.tan).padding(.top, 30).font(.system(size: 25, weight: .bold, design: .default))
                        Button(action: {
                            self.setupProxy()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 7.0, style: .continuous)
                                    .fill(Color.clear)
                                    .background(Image("bg-blur").resizable()).cornerRadius(7.0)
                                    .frame(width: geo.size.width - 50, height: 44)
                                HStack(alignment: .center, spacing: nil, content: {
                                    Text("Setup Proxy").foregroundColor(.midPurple).font(.system(size: 18, weight: .bold, design: .default))
                                })
                            }
                        }.padding(.top, 30)
                    }.offset(x: self.loginPage == .proxySetup ? 0 : self.loginPage == .proxyError ? -1.5 * geo.size.width : 1.5 * geo.size.width).padding(.horizontal, 25)

                    VStack(alignment: .leading) {
                        Text("Error enabling DNS filter. Set up the filter later to enable app-blocking.").font(.system(size: 25, weight: .semibold, design: .default)).kerning(-1).foregroundColor(Color.tan)
                        Button(action: {
                            self.loginCompleted()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 7.0, style: .continuous)
                                    .fill(Color.clear)
                                    .background(Image("bg-blur").resizable()).cornerRadius(7.0)
                                    .frame(width: geo.size.width - 50, height: 44)
                                HStack(alignment: .center, spacing: nil, content: {
                                    Text("Continue to Detach").foregroundColor(.midPurple).font(.system(size: 18, weight: .bold, design: .default))
                                })
                            }
                        }.padding(.top, 30)
                    }.offset(x: self.loginPage == .proxyError ? 0 : 1.5 * geo.size.width).padding(.horizontal, 25)

                }.padding(.top, geo.size.height * 0.13)
                Spacer()
            }.frame(width: geo.size.width, height: geo.size.height).animation(.spring())
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(loginCompleted: {})
                        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .background(Image("bg-grain").resizable())
    }
}

extension CredentialsOrError {
    var isSuccess: Bool {
        switch self {
        case .credentials: return true
        case .error: return false
        }
    }

    var values: (user: String, email: String?)? {
        switch self {
        case let .credentials(user: user, email: email):
            return (user: user, email: email)
        case .error: return nil
        }
    }

    var error: Error? {
        switch self {
        case .credentials: return nil
        case let .error(error): return error
        }
    }
}
