//
//  ModuleHandler.swift
//  Wisk
//
//  Created by Michael Westbrooks II on 5/13/18.
//  Copyright © 2018 MVPGurus. All rights reserved.
//

import Foundation
import IQKeyboardManager

class ModuleHandler {
    
    static let shared = ModuleHandler()
    
    var firebaseService: FirebaseService
    var awsService: AWSService
    var googleMapsService: GoogleMapsService
    
    //  var apiService: APIService
    //  var authenticationModule: AuthenticationModule
    //  var apiParameterLayer: APIParameterLayer
    
    //  Add additional services as needed
    //  ...
    
    private init() {
        print("Wisk | Module Handler Initialized")
        self.firebaseService = FirebaseService.shared
        self.awsService = AWSService.shared
        self.googleMapsService = GoogleMapsService.shared
        IQKeyboardManager.shared().isEnabled = true
        
        //  self.apiService = APIService.sharedInstance
        //  self.authenticationModule = AuthenticationModule.shared
        //  self.apiParameterLayer = APIParameterLayer.shared
    }
}


