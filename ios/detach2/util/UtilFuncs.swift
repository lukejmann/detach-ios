//
//  UtilFuncs.swift
//  detach2
//
//  Created by Luke Mann on 12/26/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation


    func calculateDurationSec(duration: String) -> Int {
        let hours = Int(duration[0] + duration[1])!
        let minutes = Int(duration[3] + duration[4])!
        return hours * 60 * 60 + minutes * 60
    }
