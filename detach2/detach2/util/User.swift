//
//  User.swift
//  detach2
//
//  Created by Luke Mann on 8/15/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation

public func loginUser(userID: String, email: String, completion: @escaping (_ success: Bool) -> ()) {
    setUserID(userID: userID)
    detachProvier.request(.login(userID: userID, email: email)) { result in
        print("login result: \(result)")
        completion(true)
    }
    updateApps()
}
