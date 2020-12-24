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
    var setCredentials: (_ creds: CredentialsOrError) -> Void
    var body: some View {
        let button = ButtonController(setCredentials: setCredentials)
        return button
    }

    struct ButtonController: UIViewControllerRepresentable {
        let button: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
        let vc: UIViewController = UIViewController()
        var setCredentials: (_ creds: CredentialsOrError) -> Void
        func makeCoordinator() -> Coordinator {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 300).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            return Coordinator(self)
        }

        func makeUIViewController(context _: Context) -> UIViewController {
            vc.view.addSubview(button)
            return vc
        }

        func updateUIViewController(_: UIViewController, context _: Context) {}
        class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
            let parent: ButtonController
            init(_ parent: ButtonController) {
                self.parent = parent
                super.init()
                parent.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            }

            @objc
            func didTapButton() {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.email]
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.presentationContextProvider = self
                authorizationController.delegate = self
                authorizationController.performRequests()
            }

            func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
                parent.vc.view.window!
            }

            func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
                guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
                    let e = CredentialsOrError.error(" are not of type ASAuthorizationAppleIDCredential")
                    parent.setCredentials(e)
                    return
                }
                parent.setCredentials(CredentialsOrError.credentials(user: credentials.user, email: credentials.email))
            }

            func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
                parent.setCredentials(CredentialsOrError.error(error))
            }
        }
    }
}

struct SignInWithAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButton { _ in
        }
    }
}
