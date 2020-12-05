//
//  SetDurationOverlay.swift
//  detach2
//
//  Created by Luke Mann on 12/5/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation
import SwiftUI

struct SetDurationOverlay: View {
    @State var durationString: String = "00:00"
    @State var validInput: Bool = false

    @State var keyboardVisible: Bool = true

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geo.size.width, height: geo.size.height, alignment: .leading).foregroundColor(Color.tan)
                VStack(alignment: .leading, spacing: 0.0) {
                    Text("Set Duration").font(.system(size: 25, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.darkBlue)
                    Text("Set how long selected apps will be blocked for.").font(.system(size: 14, weight: .regular, design: .default)).kerning(-1).foregroundColor(Color.darkBlue).padding(.top, 0)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        CustomUIKitTextField(text: self.$durationString, validInput: self.$validInput, isFirstResponder: self.$keyboardVisible, placeholder: "00:00").padding(.top, 30.0)
                        Spacer()
                    }.padding(.top, 20)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Rectangle().fill(Color.darkBlue).frame(width: 245, height: 1, alignment: .center)
                        Spacer()
                    }.padding(.top, 0)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("HOURS").foregroundColor(.darkBlue).font(.system(size: 16.8, weight: .regular, design: .default)).kerning(-1)
                        Spacer().frame(width: 31, height: 0, alignment: .center)
                        Text("MINUTES").foregroundColor(.darkBlue).font(.system(size: 16.8, weight: .regular, design: .default)).kerning(-1)
                        Spacer()
                    }.padding(.top, 8)
                    HStack {
                        Button(action: {}) {
                            HStack(alignment: .center, spacing: nil, content: {
                                Image("cancelIcon").resizable().frame(width: 15, height: 15, alignment: .center)
                                Text("Cancel").foregroundColor(.darkBlue).font(.system(size: 18, weight: .medium, design: .default))
                            }).frame(width: 122, height: 44).overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.darkBlue, lineWidth: 1)
                            )
                        }
                        Spacer()
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.darkBlue)
                                    .frame(width: 122, height: 44)
                                HStack(alignment: .center, spacing: nil, content: {
                                    Image("checkIcon").resizable().frame(width: 15, height: 15, alignment: .center)
                                    Text("Done").foregroundColor(.white).font(.system(size: 18, weight: .bold, design: .default))
                                })
                            }
                        }
                    }.padding(.top, 34).padding(.horizontal, 30)
                    Spacer()
                }.padding(.horizontal, 20).padding(.top, 50)
            }
        }
    }
}

struct SetDurationOverlayu_Previews: PreviewProvider {
    @State static var hasDetachPlus = false

    static var previews: some View {
        Group {
            SetDurationOverlay()
                .previewDisplayName("iPhone 11")
            //      r
        }
    }
}
