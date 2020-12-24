

import Foundation

public func loginUser(userID: String, email: String, completion: @escaping (_ success: Bool) -> Void) {
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
    var success: Bool
}
