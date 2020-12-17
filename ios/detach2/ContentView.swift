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
    @State var keyboardVisible: Bool = false
    @State var durationString: String = String(format: "%02d", getSessionDuration()/(60*60)) + ":" + String(format: "%02d", (getSessionDuration() % 3600)/(60))
    @State var sessionEndDate: Date? = nil
    
    func secondsToDurationString(seconds: Int) -> String {
        print("in seconds to duration string. seconds:\(seconds)")
        let hours = seconds / (60*60)
        let minutes = seconds / (60)
        let r = "\(hours):\(minutes)"
        print("returning \(r)")
        return r
    }
    
    func startFocusPressed() {
        let sessionDuration = getSessionDuration()
        let now = Date()
        self.sessionEndDate = now + Double(sessionDuration)
        setSessionEndDate(date: self.sessionEndDate!)
    }


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
    
    func showDurationOverlay() {
        self.showSetDuration = true
        print("calling self.keyboardVisible = true")
        self.keyboardVisible = true
    }
    
    func hideDurationOverlay(){
        self.showSetDuration = false
        print("calling self.keyboardVisible = false")
        self.keyboardVisible = false
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
            //                if self.showLoginScreen {
            //                    LoginScreen(loginCompleted: {
            //                        self.showLoginScreen = false
            //                    })
            //                } else {
            ZStack {
                HomeMenu(durationString: self.$durationString) { (screen) in
                    self.cScreen = screen
                } startFocusPressed: {
                    self.startFocusPressed()
                } showDurationScreen: {
                    self.showDurationOverlay()
                }.offset(x: self.cScreen != "HomeMenu" ? -1 * geo.size.width : 0).animation(.spring())
                SelectAppsScreen { screen in
                    self.cScreen = screen
                }.offset(x: self.cScreen == "SelectApps" ? 0 : geo.size.width, y: 0).animation(.spring())
                SessionScreen(endDate: self.$sessionEndDate) { screen in
                    self.cScreen = screen
                }.offset(x: self.cScreen == "Start" ? 0 : geo.size.width, y: 0).animation(.spring())
                SetDurationOverlay(durationString: self.$durationString, setDurationString: { str in
                    self.durationString = str
                }, keyboardVisible: self.$keyboardVisible){
                    self.hideDurationOverlay()
                }.offset(y: self.showSetDuration ? 0 : (self.cScreen != "Start" ? geo.size.height : geo.size.height + 40)).animation(.easeIn(duration: 0.15))
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
            //                }
        }.background(Image("bg-grain")).ignoresSafeArea(.keyboard)
//        .frame(width: CGFloat(UIApplication.shared.windows.first!.frame.width), height: CGFloat(UIApplication.shared.windows.first!.frame.height - (UIDevice.current.hasNotch ? 100 : 70)), alignment: .topLeading)
        .onAppear {
            self.onAppear()
        }

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
