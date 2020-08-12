//
//  StartScreen.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI
import Introspect

//reset bar and show keyboard then format

struct StartScreen: View {
    var setScreen: (_ screen: String) -> Void
    @State var sliderPercent: Float = 20
    @State var sliderMode: SliderMode = .disabled
    @State var sliderDistance: CGFloat = 0

    @State var durationString: String = "00:00"

    @State private var showProxyAlert = false

    init(setScreen: @escaping (_ screen: String) -> Void) {
        self.setScreen = setScreen
    }

    func proxyDeclined() {
        print("proxyDeclined")
        resetSlider()
    }

    func proxyAgreed() {
        print("proxyAgreed")
        resetSlider()
    }

    func resetSlider() {
        self.sliderDistance = 0
    }

    var body: some View {
        return GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Image("back").resizable().frame(width: 9, height: 17, alignment: .leading).onTapGesture {
                    self.setScreen("HomeMenu")
                }
                Text("begin blocking session").font(.custom("Georgia-Italic", size: 25)).padding(.top, 30)
                Text("SET HOW LONG THE SELECTED APPS WILL BE BLOCKED FOR").font(.system(size: 14, weight: .regular, design: .default)).padding(.top, 10)
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    CustomUIKitTextField(text: self.$durationString, sliderMode: self.$sliderMode, resetSlider: self.resetSlider, placeholder: "00:00").padding(.top, 30.0)
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
                SliderBar(percentage: self.$sliderPercent, distance: self.$sliderDistance, mode: self.$sliderMode) {
                    self.showProxyAlert.toggle()
                }.alert(isPresented: self.$showProxyAlert) {
                    Alert(
                          title: Text("Proxy Setup"),
                          message: Text("Detach uses a local DNS proxy to filter connections from the selected blocked apps. This proxy never records, collects, or stores any user data."),
                          primaryButton: .default(Text("Cancel"),
                                                  action: {
                                                    self.proxyDeclined()
                          }),
                          secondaryButton: .default(Text("Continue"),
                                                    action: {
                                                        self.proxyAgreed()
                          }))

                }

            }.padding(.top, 10).padding(.horizontal, 37)
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .topLeading)
        }
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen { (_) in
        }
    }
}

struct CustomUIKitTextField: UIViewRepresentable {

    @Binding var text: String {
        didSet {
            resetSlider()
            if text != "00:00" && sliderMode == .disabled {
                sliderMode = .proxyDisabled
            }
            if text == "00:00" && sliderMode == .proxyDisabled || sliderMode == .enabled {
                sliderMode = .disabled
            }
        }
    }
    @Binding var sliderMode: SliderMode
    var resetSlider: () -> Void

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
    }

    func makeCoordinator() -> CustomUIKitTextField.Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomUIKitTextField

        init(parent: CustomUIKitTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            defer {
                let replacementText = self.parent.hours + ":" + self.parent.minutes
                print("setting text val to \(replacementText)")
                self.parent.text = replacementText
            }

            if string == "0" && textField.text == "00:00"{
                return false
            }

            if string.isEmpty {
                if textField.text == "00:00" {
                    return false
                }
                self.parent.minutes = self.parent.hours[1] + self.parent.minutes[0]
                self.parent.hours = "0" + self.parent.hours[0]
                return true
            }

            if self.parent.hours[0] != "0"{
                return false
            }

            self.parent.hours = self.parent.hours[1] + self.parent.minutes[0]
            self.parent.minutes = self.parent.minutes[1] + string

            // return true to indicate that the textField should display the changes from the user
            return true
        }

    }
}

enum SliderMode {
    case disabled
    case proxyDisabled
    case enabled
}

struct SliderBar: View {

    @Binding var percentage: Float
    var lastPercent = 0

    @Binding var distance: CGFloat
    @Binding var mode: SliderMode

    var thresholdReached : () -> Void

    func barColor(mode: SliderMode) -> Color {
        switch mode {
        case .enabled:
            return Color.green
        case .proxyDisabled:
            return Color(red: 247/255, green: 255/255, blue: 182/255)
        default:
            return Color.gray
        }
    }

    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .foregroundColor(self.barColor(mode: self.mode))
                    Text("BEGIN SESSION").font(.system(size: 14, weight: .medium, design: .default))
                }

                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: self.distance)
                Image("slider").resizable().frame(width: 55, height: 55, alignment: .leading).padding(.leading, CGFloat(self.distance)).gesture(DragGesture(minimumDistance: 0).onEnded({ (_) in
                    self.distance = 0
                })
                    .onChanged({ value in
                        if self.mode == .disabled {
                            return
                        }
                        let xDist = value.location.x
                        if !(xDist>geometry.size.width-55 || xDist<0) {
                            self.distance = value.location.x
                            self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                            print("percent: \(self.percentage)")
                            if self.percentage > 75 {
                                print("reached 75!")
                                UIApplication.shared.hideKeyboard()
                                self.thresholdReached()
                            }
                            self.percentage = Float(self.lastPercent)
                        }
                    }))
            }.frame(width: nil, height: 55, alignment: .leading)
                .border(Color.black)
        }.frame(width: nil, height: 55, alignment: .leading).padding(.top, 42)
    }
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
