//
//  UpgradeScreen.swift
//  detach2
//
//  Created by Luke Mann on 8/20/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct UpgradeScreen: View {
    var setScreen: (_ screen: String) -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Image(self.colorScheme == .dark ? "backDark" : "backLight").resizable().frame(width: 9, height: 17, alignment: .leading).onTapGesture {
                        self.setScreen("HomeMenu")
                    }
                    Text("Upgrade To Detach Plus for $0.99 monthly.").font(.custom("Georgia-Italic", size: 25)).padding(.top, 30)
                    BulletRow(text: "Create Unlimited Sessions").padding(.top, 72)
                    BulletRow(text: "Support Regular App Updates\nAnd Improvements").padding(.top, 42)
                    BulletRow(text: "Daily DNS Proxy Filter Updates ").padding(.top, 42)

//                    Text("SELECT WHICH APPS ARE BLOCKED DURING\nA SESSON").font(.system(size: 14, weight: .regular, design: .default)).padding(.top, 10)
                }.padding(.horizontal, 37)

            }.padding(.top, 80).frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
        }
    }
}

struct Bullet: View {
    var text: String

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
//        GeometryReader { geo in

            HStack {
                ZStack(alignment: .center) {
                    Rectangle()
                        .border(self.colorScheme == .dark ? Color.white : Color.black, width: 2)
                        .frame(width: 20, height: 20, alignment: .leading)
                        .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0, opacity: 0))
                    Rectangle()
                        .frame(width: 8, height: 8, alignment: .leading).foregroundColor(Color(hue: 0, saturation: 0, brightness: self.colorScheme == .dark ? 1 : 0, opacity: 1.0))
                }
                Text(self.text).multilineTextAlignment(.leading).lineLimit(nil).font(.system(size: 20, weight: .regular, design: .default)).frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                )
            }
//        }
    }
}

struct UpgradeScreen_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeScreen {
            _ in
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
        .previewDisplayName("iPhone 11 Pro")
    }
}
