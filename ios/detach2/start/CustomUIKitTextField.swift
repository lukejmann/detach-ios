//
//  CustomUIKitTextField.swift
//  detach2
//
//  Created by Luke Mann on 8/12/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct CustomUIKitTextField: UIViewRepresentable {
    @Binding var text: String {
        didSet {
            resetSlider()
            if text != "00:00" && startMode == .disabled {
                let userAgreedToVPN = getUserAgreedToVPN()
                if TunnelController.shared.status() == .connected{
                    self.startMode = .proxyEnabled
                } else {
                    self.startMode = .validInput
                }
            }
            if text == "00:00" && startMode == .validInput {
                self.startMode = .disabled
            }
        }
    }

    @Binding var startMode: StartMode
    @Binding var isFirstResponder: Bool

    var resetSlider: () -> Void
//    var setValidInput

    var placeholder: String

    var hours = "00"
    var minutes = "00"

    func makeUIView(context: UIViewRepresentableContext<CustomUIKitTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomUIKitTextField>) {
        uiView.text = text
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
        uiView.font = UIFont(name: "NewYorkLarge-SemiboldItalic", size: 70)
        uiView.keyboardType = .numberPad
        uiView.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        uiView.textAlignment = .center
        if isFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }

    func makeCoordinator() -> CustomUIKitTextField.Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomUIKitTextField

        var didBecomeFirstResponder = false

        init(parent: CustomUIKitTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
            defer {
                let replacementText = self.parent.hours + ":" + self.parent.minutes
                self.parent.text = replacementText
            }

            if string == "0", textField.text == "00:00" {
                return false
            }

            if string.isEmpty {
                if textField.text == "00:00" {
                    return false
                }
                parent.minutes = parent.hours[1] + parent.minutes[0]
                parent.hours = "0" + parent.hours[0]
                return true
            }

            if parent.hours[0] != "0" {
                return false
            }

            parent.hours = parent.hours[1] + parent.minutes[0]
            parent.minutes = parent.minutes[1] + string

            // return true to indicate that the textField should display the changes from the user
            return true
        }
    }
}

struct CustomUIKitTextField_Previews: PreviewProvider {
    static var previews: some View {
      Text("N/A")
    }
}
