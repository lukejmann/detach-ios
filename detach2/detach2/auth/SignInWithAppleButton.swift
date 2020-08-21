//
//  SignInWithAppleButton.swift
//  iOS-Demo-SignInWithApple-SwiftUI
//
//  Created by Jaap Mengers on 05/06/2019.
//  Copyright © 2019 Jaap Mengers. All rights reserved.
//

import AuthenticationServices
import SwiftUI

extension String: Error {}

enum CredentialsOrError {
    case credentials(user: String, email: String?)
    case error(_ error: Error)
}

struct Credentials {
    let user: String
    let email: String?
}

struct SignInWithAppleButton: View {
//    @Binding var credentials: CredentialsOrError?
    
    var setCredentials: (_ creds: CredentialsOrError) -> ()
  
    var body: some View {
        let button = ButtonController(setCredentials: setCredentials)
    
        return button
            .frame(width: button.button.frame.width, height: button.button.frame.height, alignment: .center)
    }
  
    struct ButtonController: UIViewControllerRepresentable {
        let button: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
        let vc: UIViewController = UIViewController()
        var setCredentials: (_ creds: CredentialsOrError) -> ()

    
//        @Binding var credentials: CredentialsOrError?
    
        func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }
    
        func makeUIViewController(context: Context) -> UIViewController {
            vc.view.addSubview(button)
            return vc
        }
    
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
        class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
            let parent: ButtonController
      
            init(_ parent: ButtonController) {
                self.parent = parent
        
                super.init()
        
                parent.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            }
      
            @objc func didTapButton() {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.email]
        
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.presentationContextProvider = self
                authorizationController.delegate = self
                authorizationController.performRequests()
            }
      
            func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
                return parent.vc.view.window!
            }
      
            func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
                guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
                    let e = CredentialsOrError.error(" are not of type ASAuthorizationAppleIDCredential")
                    parent.setCredentials(e)

                    return
                }
                parent.setCredentials(CredentialsOrError.credentials(user: credentials.user, email: credentials.email))
//
//                parent.credentials = .credentials(user: credentials.user, email: credentials.email)
            }
      
            func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
                parent.setCredentials(CredentialsOrError.error(error))
            }
        }
    }
}

struct SignInWithAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
