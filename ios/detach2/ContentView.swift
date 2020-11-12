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
    @State var showLoginScreen = getUserID() == "N/A userID"
    @State var hasDetachPlus = false

    @Environment(\.colorScheme) var colorScheme

    func onAppAppears() {
        if Date() > timerEnd {
            TunnelController.shared.disable()
            cScreen = "HomeMenu"
        }
        checkSubscription()
        refreshSupportedApps()
    }

    func checkSubscription() {
        checkUserReceipt { success in
            if success {
                let subStatus = getSubStatus()
                if subStatus != nil {
                    print("in check sub. subStatus: \(subStatus?.status)")
                    self.hasDetachPlus = subStatus?.status == "active"
                }
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
//        VStack {
            VStack {
                if self.showLoginScreen {
                    LoginScreen(loginCompleted: {
                        self.showLoginScreen = false
                    })
                } else {
                    if self.cScreen == "HomeMenu" {
                        HomeMenu(hasDetachPlus: self.$hasDetachPlus) { screen in
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
                    } else if self.cScreen == "Upgrade" {
                        UpgradeScreen(parentRefreshSubStatus: self.checkSubscription) { screen in
                            self.cScreen = screen
                        }
                    } else {
                        Text("Unknown Screen" + self.cScreen)
                    }
                }
            }
        }
    }
}

// .frame(width: CGFloat(UIApplication.shared.windows.first!.frame.width), height: CGFloat(UIApplication.shared.windows.first!.frame.height - (UIDevice.current.hasNotch ? 100 : 70)), alignment: .topLeading).onAppear {
//    self.onAppAppears()
// }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
