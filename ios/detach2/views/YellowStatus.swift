//
//  YellowStatus.swift
//  detach2
//
//  Created by Luke Mann on 12/23/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI
import NetworkExtension

struct YellowStatus: View {
    @State var nFrame = 1
    @Binding var proxyStatus: NEVPNStatus {
        didSet {
            if self.proxyStatus == .connecting {
                self.nFrame = 1
            }
        }
    }
    
    var frameImage: String {
        switch self.nFrame{
        case 1:
            return "yellowStatus1"
        case 2:
            return "yellowStatus2"
        case 3:
            return "yellowStatus3"
        case 4:
            return "yellowStatus4"
        case 5:
            return "yellowStatus5"
        default:
            return "yellowStatus6"
        }
    }
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader{ geo in
            Image(self.frameImage).resizable().frame(width: 16, height: 16, alignment: .center)
        }.onReceive(timer, perform: { _ in
            if self.proxyStatus == .disconnecting || self.proxyStatus == .connecting {
                if nFrame > 4 {
                    self.nFrame = 1
                } else {
                    self.nFrame += 1
                }
            }
        })
    }
}
