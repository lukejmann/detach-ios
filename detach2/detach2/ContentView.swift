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
        loginUser()

        if Date() > timerEnd {
            TunnelController.shared.disable()
            self.cScreen = "HomeMenu"
        }
    }

    var body: some View {
        GeometryReader { geo in
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
                } else if self.cScreen == "SelectApps" {
                    SelectAppsScreen { screen in
                        self.cScreen = screen
                    }
                } else {
                    Text("Unknown Screen" + self.cScreen)
                }
            }.frame(width: CGFloat(UIApplication.shared.windows.first!.frame.width), height: CGFloat(UIApplication.shared.windows.first!.frame.height+10), alignment: .topLeading).onAppear {
                self.onAppAppears()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
