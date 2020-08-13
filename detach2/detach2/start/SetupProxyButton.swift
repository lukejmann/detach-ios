//
//  SetupProxyButton.swift
//  detach2
//
//  Created by Luke Mann on 8/12/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct SetupProxyButton: View {
    @Binding var mode: StartMode 

    @State private var showProxyAlert = false

    var proxyDeclined: () -> Void
    var proxyAgreed: () -> Void
    var hideKeyboard: () -> Void

    enum ButtonMode {
        case pressed
        case notPressed
    }

    @State var pressType: ButtonMode = .notPressed

    func backgroundColor(mode: StartMode, pressType: ButtonMode) -> Color {
        switch mode {
        case .validInput:
            if pressType == .pressed {
                return Color.orange
            }
            return Color.yellow
        default:
            return Color.gray
        }
    }

    func btnText(mode: StartMode) -> String {
        switch mode {
//        case .proxyEnabled:
//            return "SUCCESS"
        default:
            return "SETUP PROXY"
        }
    }

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .foregroundColor(self.backgroundColor(mode: self.mode, pressType: self.pressType))
                    Text(self.btnText(mode: self.mode)).foregroundColor(.white).font(.system(size: 14, weight: .medium, design: .default))
                }.onTapGesture {
                    if self.pressType == .pressed {
                        return
                    }
                    self.pressType = .pressed
//                    self.hideKeyboard()
                    self.showProxyAlert.toggle()

                }.alert(isPresented: self.$showProxyAlert) {
                    Alert(
                        title: Text("Proxy Setup"),
                        message: Text("Detach uses a local DNS proxy to filter connections from the selected blocked apps. This proxy never records, collects, or stores any user data."),
                        primaryButton: .default(
                            Text("Cancel"),
                            action: {
                                self.proxyDeclined()
                            }),
                        secondaryButton: .default(
                            Text("Continue"),
                            action: {
                                self.proxyAgreed()
                            }))
                }
            }.frame(width: nil, height: 55, alignment: .leading)
                .border(Color.black)
        }.frame(width: nil, height: 55, alignment: .leading).padding(.top, 42)
    }
}

struct SetupProxyButton_Previews: PreviewProvider {
    static var previews: some View {
        Text("N/A")
    }
}
