//
//  SessionManager.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit

class SessionManager {
    
    static var loginInfo : LoginModel? = nil
    // To save login response
    static func saveSessionInfo(loginResponse: LoginModel) {
        defaults.set(true, forKey: UserDefaultsKeys.loggedInStatus)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(loginResponse) {
            defaults.set(encoded, forKey: UserDefaultsKeys.userLoggedIn)
            SessionManager.SessionLoginInfo()
        }
    }
    
    static func SessionLoginInfo() {
         print("User info retrieve")
        // decoding login api and assigning data
        if let savedPerson = UserDefaults.standard.object(forKey: UserDefaultsKeys.userLoggedIn) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginModel.self, from: savedPerson) {
                self.loginInfo = loadedPerson
            }
        }
    }
    static func logoutUser() {
        defaults.set(nil, forKey: UserDefaultsKeys.userLoggedIn)
        defaults.set(false, forKey: UserDefaultsKeys.loggedInStatus)
    }
}
