//
//  CustomUIKitTextField.swift
//  detach2
//
//  Created by Luke Mann on 8/12/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

// make final class? https://developer.apple.com/forums/thread/124671
struct CustomUIKitTextField: UIViewRepresentable {
    @Binding var text: String {
        didSet {
            validInput = text != "00:00"
        }
    }

    @Binding var validInput: Bool
    @Binding var isFirstResponder: Bool

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
        uiView.textColor = UIColor(Color.darkBlue)
        uiView.tintColor = UIColor(Color.darkBlue)
        uiView.textAlignment = .center
        print("isFirstResponder in updateUIView:\(isFirstResponder)")
        if isFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        } else {
            uiView.resignFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
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

extension StringProtocol {
    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }
}