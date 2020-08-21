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
                    BulletPoints()
                    HStack(alignment: .center) {
                        ZStack(alignment: .center) {
                            Rectangle().frame(width: 243, height: 57).foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                            Text("PURCHASE DETACH PLUS").font(.system(size: 16, weight: .regular, design: .default)).foregroundColor(self.colorScheme == .dark ? Color.black : Color.white)
                        }
                    }.padding(.top, 80).frame(maxWidth: .infinity)
                    Text("TERMS AND CONDITIONS").font(.system(size: 14, weight: .regular, design: .default)).foregroundColor(self.colorScheme == .dark ? Color.white : Color.black).padding(.top,58)
                    Text("RESTORE PURCHASE").font(.system(size: 14, weight: .regular, design: .default)).foregroundColor(self.colorScheme == .dark ? Color.white : Color.black).padding(.top,6)


  
                }.padding(.horizontal, 37)

            }.padding(.top, 80).frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
        }
    }
}

struct Bullet: View {
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
        }
//        }
    }
}

struct UpgradeScreen_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeScreen {
            _ in
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    }
}

struct BulletPoints: View {
    var body: some View {
        Group {
            HStack {
                Bullet()
                Text("Create Unlimited Sessions").padding(.leading, 6).multilineTextAlignment(.leading).lineLimit(nil).font(.system(size: 20, weight: .regular, design: .default))
            }.padding(.top, 72)
            HStack {
                Bullet()
                VStack(alignment: .leading) {
                    Text("Support Regular App Updates").padding(.leading, 6).multilineTextAlignment(.leading).lineLimit(nil).font(.system(size: 20, weight: .regular, design: .default))
                    Text("and Improvements").padding(.leading, 6).multilineTextAlignment(.leading).lineLimit(nil).font(.system(size: 20, weight: .regular, design: .default))
                }

            }.padding(.top, 42)
            HStack {
                Bullet()
                Text("Daily DNS Proxy Filter Updates").padding(.leading, 6).multilineTextAlignment(.leading).lineLimit(nil).font(.system(size: 20, weight: .regular, design: .default))
            }.padding(.top, 42)
        }
    }
}
