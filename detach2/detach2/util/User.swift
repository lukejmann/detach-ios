//
//  User.swift
//  detach2
//
//  Created by Luke Mann on 8/15/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation


func loginUser() {
    setUserID(userID: "1")
    detachProvier.request(.login(userID: "1", email: "l@mann.xyz")) { result in
        print("login result: \(result)")
    }
    updateApps()
}
