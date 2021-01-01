import SwiftUI
struct CustomUIKitTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool

    var hours = "00"
    var minutes = "00"
    func makeUIView(context: UIViewRepresentableContext<CustomUIKitTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.text
        return textField
    }





    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomUIKitTextField>) {
        uiView.text = text
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
        uiView.font = UIFont(name: "NewYorkLarge-BoldItalic", size: 60)
        uiView.keyboardType = .numberPad
        uiView.textColor = UIColor(Color.midPurple)
        uiView.tintColor = UIColor(Color.clear)
        uiView.textAlignment = .center
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

        func textFieldDidEndEditing(_: UITextField, reason _: UITextField.DidEndEditingReason) {
            parent.hours = "00"
            parent.minutes = "00"
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
            defer {
                let replacementText = self.parent.hours + ":" + self.parent.minutes
                self.parent.text = replacementText
            }

            if string.isEmpty {
                if textField.text == "00:00" {
                    return false
                }
                parent.minutes = parent.hours[1] + parent.minutes[0]
                parent.hours = "0" + parent.hours[0]
                return false
            }
            if parent.hours[0] != "0" {
                return false
            }
            parent.hours = parent.hours[1] + parent.minutes[0]
            parent.minutes = parent.minutes[1] + string
            return false
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

