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
    @State var hasDetachPlus = true
    @State var showSetDuration = false
    
    
    @Environment(\.colorScheme) var colorScheme
    
    func onAppear() {
        print("in app appeared")
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
                    //                    self.hasDetachPlus = subStatus?.status == "active"
                    self.hasDetachPlus = true
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
                if self.showLoginScreen {
                    LoginScreen(loginCompleted: {
                        self.showLoginScreen = false
                    })
                } else {
                    ZStack{
                        HomeMenu() { screen in
                            self.cScreen = screen
                        } showDurationScreen: {
                            self.showSetDuration = true
                        }.offset(x: self.cScreen != "HomeMenu" ? -1 * geo.size.width : 0).animation(.spring())
                        SelectAppsScreen { screen in
                            self.cScreen = screen
                        }.offset(x: self.cScreen == "SelectApps" ? 0 : geo.size.width, y: 0).animation(.spring())
                        ZStack{
                            Rectangle().frame(width: geo.size.width, height:  geo.size.height, alignment: .leading).foregroundColor(Color.tan)
                            Text("set duration")
                            Spacer()
                        }.background(Color.tan).offset(y: (self.showSetDuration ? 0 : geo.size.height)).animation(.easeIn(duration: 0.15))
                    }
                    
                    
                    //                    else if self.cScreen == "Start" {
                    //                        StartScreen { screen in
                    //                            self.cScreen = screen
                    //                        }
                    //                    } else if self.cScreen == "Session" {
                    //                        SessionScreen { screen in
                    //                            self.cScreen = screen
                    //                        }
                    //                    } else if self.cScreen == "SelectApps" {
                    
                    //                    } else if self.cScreen == "Upgrade" {
                    //                        UpgradeScreen(parentRefreshSubStatus: self.checkSubscription) { screen in
                    //                            self.cScreen = screen
                    //                        }
                    //                    } else {
                    //                        Text("Unknown Screen" + self.cScreen)
                    //                    }
                }
            }
        .frame(width: CGFloat(UIApplication.shared.windows.first!.frame.width), height: CGFloat(UIApplication.shared.windows.first!.frame.height - (UIDevice.current.hasNotch ? 100 : 70)), alignment: .topLeading).onAppear {
            self.onAppear()
        }.background(Image("bg-grain"))
    }
}

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
