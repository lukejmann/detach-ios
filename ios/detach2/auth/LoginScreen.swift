//
//  LoginScreen.swift
//  detach2
//
//  Created by Luke Mann on 8/16/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

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
                print("loginUser completin. success: \(success)")
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
                // TODO: handle
            }
        }
    }

    var body: some View {
        GeometryReader { _ in
            if self.loginPage == .descriptionOne {
                VStack {
                    Text("Our phones are great, but it’s become increasingly difficult to use them without getting distracted.").font(.custom("Georgia", size: 25))
                    Text("Detach temorarily blocks chosen apps from your phone so you can stay focused.").font(.custom("Georgia-Italic", size: 25)).padding(.top, 30)
                    ZStack(alignment: .center) {
                        Rectangle().foregroundColor(Color.black).frame(width: 110, height: 40)
                        Text("NEXT").font(.system(size: 16, weight: .regular, design: .default)).foregroundColor(self.colorScheme == .dark ? Color.black : Color.white).onTapGesture {
                            self.loginPage = .signIn
                        }
                    }.padding(.top, 40).alignmentGuide(.bottom) { _ in 0 }
                }
            } else if self.loginPage == .signIn {
                VStack {
                    Text("Login or create an account to get started.").font(.custom("Georgia", size: 25))
                    SignInWithAppleButton(setCredentials: self.setCredentials).frame(width: 300, height: 44, alignment: .center).padding(.top, 83)
                }
            } else if self.loginPage == .proxySetup {
                VStack {
                    Text("Last step! Detach blocks apps by preventing them from connecting to the internet using a DNS filter.").font(.custom("Georgia", size: 25))
                    Text("To proceed, please enable the DNS filter.").font(.custom("Georgia-Italic", size: 25)).padding(.top, 30)
                    ZStack(alignment: .center) {
                        Rectangle().foregroundColor(Color.black).frame(width: 146, height: 40)
                        Text("SETUP PROXY").font(.system(size: 15, weight: .regular, design: .default)).foregroundColor(self.colorScheme == .dark ? Color.black : Color.white).onTapGesture {
                            self.setupProxy()
                        }
                    }
                }
            } else {
                Text("error")
//                .frame(width: geo.size.width, height: geo.size.height)
            }
        }.padding(.horizontal, 37).padding(.top, 100)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(loginCompleted: {})
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone 11 Pro")
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
