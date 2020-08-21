//
//  LoginScreen.swift
//  detach2
//
//  Created by Luke Mann on 8/16/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import AuthenticationServices
import SwiftUI

struct LoginScreen: View {
    var loginCompleted: () -> Void

    
    func setCredentials(creds: CredentialsOrError) {
        if creds.isSuccess {
            loginUser(userID: creds.values?.user ?? "", email: creds.values?.email ?? "") { (success) in
                print("loginUser completin. success: \(success)")
                if success {
                    self.loginCompleted()
                }
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                    SignInWithAppleButton(setCredentials: self.setCredentials)
              
            }.frame(width: geo.size.width, height: geo.size.height)
        }
//
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen {
         
        }
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
