//
//  SessionScreen.swift
//  detach2
//
//  Created by Luke Mann on 8/13/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct SessionScreen: View {
    var setScreen: (_ screen: String) -> Void

    func timerEndString() -> String {
        let calendar = Calendar.current
        let df = DateFormatter()
        df.amSymbol = "am"
        df.pmSymbol = "pm"

        df.dateFormat = "hh:mm a."
//        : "hh:mm a.'on' MMMM dd"
        if calendar.isDateInTomorrow(timerEnd) {
            df.dateFormat = "hh:mm a 'tommorow.'"
            df.amSymbol = "a.m."
            df.pmSymbol = "p.m."
        } else if !calendar.isDateInToday(timerEnd) {
            df.dateFormat = "hh:mm a.'on' MMMM dd"
        }

        return df.string(from: timerEnd)
    }

    func cancelPressed() {
        let userID = getUserID()
        let sessionID = getSessionID()
        let opt = SessionCancelOpt(userID: userID, sessionID: sessionID)
        detachProvier.request(.cancelSession(opt: opt)) { result in
            print(" in cancelRession compltion. result: \(result)")
            self.setScreen("HomeMenu")
        }
        self.setScreen("HomeMenu")
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("sessionBG").resizable().frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                VStack(alignment: .leading, spacing: 0) {
                    Text("apps blocked until \(self.timerEndString())").font(.custom("Georgia-Italic", size: 40)).padding(.top, 150).foregroundColor(.white).accentColor(.white)

                    ZStack {
                        Rectangle().foregroundColor(Color.white).frame(width: 136, height: 48, alignment: .topLeading)
                        Text("CANCEL").foregroundColor(.black).font(.system(size: 14, weight: .regular, design: .default))

                    }.padding(.top, 60).onTapGesture() {
                        self.cancelPressed()
                    }
                }.padding(.horizontal, 42)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .topLeading)
        }.background(Color.black).onAppear {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
}

struct SessionScreen_Previews: PreviewProvider {
    static var previews: some View {
        SessionScreen { _ in
        }
    }
}
