//
//  ContentView.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State public var cScreen: String = "HomeMenu"
    @Environment(\.colorScheme) var colorScheme

    func onAppAppears() {
        setUserID(userID: "1")
        detachProvier.request(.login(userID: "1", email: "l@mann.xyz")) { result in
            print("login result: \(result)")
        }
        if Date() > timerEnd {
            TunnelController.shared.disable()
        }
    }

    var body: some View {
        VStack {
            if self.cScreen == "HomeMenu" {
                HomeMenu { screen in
                    self.cScreen = screen
                }
            } else if self.cScreen == "Start" {
                StartScreen { screen in
                    self.cScreen = screen
                }
            } else if self.cScreen == "Session" {
                SessionScreen { screen in
                    self.cScreen = screen
                }
            } else {
                Text("Unknown Screen" + self.cScreen)
            }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).edgesIgnoringSafeArea(.all).onAppear {
            self.onAppAppears()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
