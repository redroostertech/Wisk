//
//  UserDefaults+Extensions.swift
//  Wisk
//
//  Created by Michael Westbrooks on 3/27/18.
//  Copyright © 2018 MVPGurus. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    
    struct AuthenticationKeys {
        static let sessionActive = "sessionActive"
        static let loggedInFailedAttempts = "loggedInFailedAttempts"
    }
    
    struct UserSettings {
        static let userid = "userID"
        static let username = "username"
    }
    
}

extension UIViewController {
    func storeLocalProperties(data: Any, completion: @escaping () -> Void) {
        //UserDefaults.standard.set(data.getUserid(), forKey: UserDefaults.UserSettings.userid)
        //UserDefaults.standard.set(data.getUsername(), forKey: UserDefaults.UserSettings.username)
        UserDefaults.standard.set(true, forKey: UserDefaults.AuthenticationKeys.sessionActive)
        completion()
        
    }
    
    func destroyLocalDefaultProperties(completion: @escaping () -> Void) {
        UserDefaults.standard.set(nil, forKey: UserDefaults.UserSettings.userid)
        UserDefaults.standard.set(nil, forKey: UserDefaults.UserSettings.username)
        UserDefaults.standard.set(nil, forKey: UserDefaults.AuthenticationKeys.sessionActive)
        completion()
    }
}
