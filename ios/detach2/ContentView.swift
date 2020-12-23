//
//  ContentView.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI
import NetworkExtension


struct ContentView: View {
    @State public var cScreen: String = "HomeMenu"
    @State var showLoginScreen = getUserID() == "N/A userID"
    @State var hasDetachPlus = true
    @State var showSetDuration = false
    @State var keyboardVisible: Bool = false
    @State var durationString: String = String(format: "%02d", getSessionDuration() / (60 * 60)) + ":" + String(format: "%02d", (getSessionDuration() % 3600) / 60)
    @State var sessionEndDate: Date? = nil
    @State var proxyStatus: NEVPNStatus = .invalid
    
    func startFocusPressed() {
        let sessionDuration = getSessionDuration()
        let now = Date()
        sessionEndDate = now + Double(sessionDuration)
        setSessionEndDate(date: sessionEndDate!)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
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
        showSetDuration = true
        print("calling self.keyboardVisible = true")
        keyboardVisible = true
    }
    
    func hideDurationOverlay() {
        showSetDuration = false
        print("calling self.keyboardVisible = false")
        keyboardVisible = false
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
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5){
                        Text("Distraction-Blocking Proxy").kerning(-0.5).font(.system(size: 14, weight: .bold, design: .default)).foregroundColor(Color.tan)
                        if self.proxyStatus == .connected{
                            HStack(alignment: .center){
                                Image("greenStatus").resizable().frame(width: 10, height: 10, alignment: .center)
                                Text("Connected").kerning(-0.4).font(.system(size: 14, weight: .medium, design: .default)).foregroundColor(Color.tan)
                            }
                        } else {
                            HStack(alignment: .center){
                                Image("greyStatus").resizable().frame(width: 10, height: 10, alignment: .center)
                                Text("Disconnected").kerning(-0.4).font(.system(size: 14, weight: .medium, design: .default)).foregroundColor(Color.tan)
                            }
                        }
                        
                        
                    }.padding(.trailing, 16)
                }.onReceive(timer) { _ in
                    self.proxyStatus = TunnelController.shared.status()
                }.padding(.top, 30)
            ZStack {
                    HomeMenu(durationString: self.$durationString) { screen in
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
                    }, keyboardVisible: self.$keyboardVisible) {
                        self.hideDurationOverlay()
                    }.offset(y: self.showSetDuration ? 0 : (self.cScreen != "Start" ? geo.size.height : geo.size.height + 40)).animation(.easeIn(duration: 0.15))
                }
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
