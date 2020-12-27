//
//  UtilFuncs.swift
//  detach2
//
//  Created by Luke Mann on 12/26/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation
import NetworkExtension


    func calculateDurationSec(duration: String) -> Int {
        let hours = Int(duration[0] + duration[1])!
        let minutes = Int(duration[3] + duration[4])!
        return hours * 60 * 60 + minutes * 60
    }


func readableStatus(status: NEVPNStatus) -> String {
    switch status {
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

