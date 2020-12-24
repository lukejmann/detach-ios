import AuthenticationServices
import SwiftUI
enum loginPage {
    case descriptionOne
    case signIn
    case proxySetup
}

struct LoginScreen: View {
    var loginCompleted: () -> Void
    @State var loginPage: loginPage = .descriptionOne
    @Environment(\.colorScheme) var colorScheme
    func setCredentials(creds: CredentialsOrError) {
        if creds.isSuccess {
            loginUser(userID: creds.values?.user ?? "", email: creds.values?.email ?? "") { success in
                print("loginUser completion. success: \(success)")
                if success {
                    self.loginPage = .proxySetup
                }
            }
        }
    }

    func setupProxy() {
        connectProxy(i: 0) { success in
            if success {
                self.loginCompleted()
            } else {
                // MARK: TODO: handle err
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text("detach").font(.custom("Georgia-Italic", size: 42)).foregroundColor(Color.tan)
                }.frame(width: geo.size.width, height: .none, alignment: .center).padding(.top, 60)
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("Our phones are great, but it’s become increasingly difficult to use them without getting distracted.").font(.system(size: 25, weight: .semibold, design: .default)).kerning(-0.8).foregroundColor(Color.tan)
                        Text("Detach temorarily blocks chosen apps from your phone so you can stay focused.").font(.system(size: 25, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan).padding(.top, 30)
                        HStack {
                            Spacer()
                            Button(action: {
                                self.loginPage = .signIn
                            }) {
                                    Image("rightArrow").resizable().frame(width: 52.25, height: 25, alignment: .center)
                            }
                        }.frame(width: 0.9 * geo.size.width).padding(.top, 40)
                    }.offset(x: self.loginPage == .descriptionOne ? 0 : -1.5 * geo.size.width).padding(.horizontal, 25)
                    VStack {
                        Text("Login or create an account to get started.").font(.system(size: 25, weight: .semibold, design: .default)).kerning(-0.5).foregroundColor(Color.tan).frame(width: 300, height: .none)
                        HStack {
                            Spacer()
                            SignInWithAppleButton(setCredentials: self.setCredentials).frame(width: 300, height: 44, alignment: .center).padding(.top, 30)
                            Spacer()
                        }
                    }.offset(x: self.loginPage == .signIn ? 0 : self.loginPage == .descriptionOne ? 1.5 * geo.size.width : -1.5 * geo.size.width)
                    VStack(alignment: .leading) {
                        Text("Last step! Detach blocks apps by preventing them from connecting to the internet using a DNS filter.").font(.system(size: 25, weight: .semibold, design: .default)).kerning(-1).foregroundColor(Color.tan)
                        Text("To proceed, please enable the DNS filter.").kerning(-1).foregroundColor(Color.tan).padding(.top, 30).font(.system(size: 25, weight: .bold, design: .default))
                        Button(action: {
                            self.setupProxy()
                        }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.darkBlue)
                                        .frame(width: geo.size.width - 50, height: 44)
                                    HStack(alignment: .center, spacing: nil, content: {
                                        Text("Setup Proxy").foregroundColor(.white).font(.system(size: 18, weight: .bold, design: .default))
                                    })
                                }
                        }.padding(.top, 30)
                    }.offset(x: self.loginPage == .proxySetup ? 0 : 1.5 * geo.size.width).padding(.horizontal, 25)

                }.padding(.top, 100)
                Spacer()
            }.frame(width: geo.size.width, height: geo.size.height).animation(.spring())
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(loginCompleted: {})
//            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone 11 Pro").background(Image("bg-grain").resizable())
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
