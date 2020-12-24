//
//  StatusIndicator.swift
//  detach2
//
//  Created by Luke Mann on 12/23/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI
import NetworkExtension
import Combine


struct StatusIndicator: View {
    
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var proxyStatus: NEVPNStatus
    @Binding var cScreen: String

    var proxyStatusText: String {
        switch self.proxyStatus {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .disconnected:
            return "Disconnected"
        case .disconnecting:
            return "Disconnecting"
        case .invalid:
            return "Invalid"
        case .reasserting:
            return "Reasserting"
        }
    }

    var body: some View {
          GeometryReader { geo in

                VStack(alignment: .trailing, spacing: 5){
                    Text("Distraction-Blocking Proxy").kerning(-0.5).font(.system(size: 14, weight: .bold, design: .default)).foregroundColor(Color.tan)
                    HStack(alignment: .center){
                        HStack{
                            switch self.proxyStatus {
                            case .connected:
                                Image("greenStatus").resizable().frame(width: 16, height: 16, alignment: .center)
                            case .connecting:
                                YellowStatus(proxyStatus: self.$proxyStatus)
                            case .disconnecting:
                                YellowStatus(proxyStatus: self.$proxyStatus)
                            default:
                                Image("greyStatus").resizable().frame(width: 8, height: 8, alignment: .center)
                            }
                        }.frame(width: 16, height: 16)
                        Text(self.proxyStatusText).kerning(-0.4).font(.system(size: 14, weight: .medium, design: .default)).foregroundColor(Color.tan)
                        
                    }
 
                
            }.onReceive(timer) { _ in
                var status = TunnelController.shared.status()
                if self.cScreen == "Start" && status == .disconnected{
                    status = .connecting
                }
                self.proxyStatus = status
            }.padding(.trailing, 30).padding(.top, 30)
        }
    }
    
}
