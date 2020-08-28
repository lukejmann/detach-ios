//
//  HomeMenu.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct HomeMenu: View {
    @Binding var hasDetachPlus: Bool
    var setScreen: (_ screen: String) -> Void

    var canStartSession: Bool {
        print("getTrialSession()?.date: \(getTrialSession()?.date)")
        let trialS = getTrialSession()
        if trialS != nil {
            return self.hasDetachPlus || !trialS!.date.isToday()
        }
        return true
    }

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Text("detach").font(.custom("Georgia-Italic", size: 42)).padding(.top, 100)

                if !self.canStartSession {
                    ZStack(alignment: .center) {
                        Rectangle().foregroundColor(Color(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.1)).border(Color.red).frame(width: geometry.size.width - 65 * 2, height: 50).cornerRadius(5).clipped()
                        Text("Daily session limit reached. Upgrade to\nDetach Plus for unlimited sessions.").font(.system(size: 14, weight: .medium, design: .default)).foregroundColor(.red)
                    }.padding(.top, 20)
                }
                VStack(alignment: .center, spacing: 75) {
//                NavigationLink(destination: StartView()){
                    HStack(alignment: .center, spacing: 28) {
                        VStack {
                            Image(self.colorScheme == .dark ? "startDark" : "startLight").resizable().frame(width: 58, height: 58, alignment: .center)
                        }.frame(width: 60, height: 60, alignment: .leading)
                        VStack(alignment: .leading, spacing: -12) {
                            Text("START")
                            Text("BLOCKING")
                        }
                    }.onTapGesture {
                        if self.canStartSession {
                            self.setScreen("Start")
                        }
                    }.opacity(self.canStartSession ? 1.0 : 0.6).frame(width: 290, height: 70, alignment: .leading)

                    HStack(alignment: .center, spacing: 28) {
                        VStack {
                            Image(self.colorScheme == .dark ? "selectDark" : "selectLight").resizable().frame(width: 50, height: 50, alignment: .center)
                        }.frame(width: 60, height: 60, alignment: .leading)
                        VStack(alignment: .leading, spacing: -12) {
                            Text("SELECT")
                            Text("APPS")
                        }
                    }.onTapGesture {
                        self.setScreen("SelectApps")
                    }.frame(width: 290, height: 70, alignment: .leading)

                    HStack(alignment: .center, spacing: 28) {
                        VStack {
                            Image(self.colorScheme == .dark ? "plusDark" : "plusLight").resizable().frame(width: 50, height: 50, alignment: .center)
                        }.frame(width: 60, height: 60, alignment: .leading)
                        VStack(alignment: .leading, spacing: -12) {
                            Text("DETACH")
                            Text("PLUS")
                        }
                    }.onTapGesture {
                        self.setScreen("Upgrade")
                    }.frame(width: 290, height: 70, alignment: .leading)
                }.font(.system(size: 40, weight: .medium, design: .default)).padding(.top, 60)
                Spacer()
            }.frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center)
        }
    }
}

struct HomeMenu_Previews: PreviewProvider {
    @State static var hasDetachPlus = false

    static var previews: some View {
        HomeMenu(hasDetachPlus: self.$hasDetachPlus) {
            _ in
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    }
}

extension Date {
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}
