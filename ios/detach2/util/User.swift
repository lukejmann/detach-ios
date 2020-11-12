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
        switch result {
            case let .success(moyaResponse):
            print("log in successful.")
            completion(true)
            case let .failure(error):
                print("failure updating appDomains")
                
        }
        completion(true)
    }
    refreshSupportedApps()
}

public struct LoginRes: Decodable {
    var subStatus: SubStatus
    var success: Bool
}




//
// User Flow:
// first app open ever:
//      - get userID from SignIn
//      - save userID
//      - mark user not subscribed
// reopens app:
//      - if userID stored:
//            - check if user is subscribed
//            - proceed to app
//      - else:
//            - make user log back in
//
//
//
//
//
//
//
//
