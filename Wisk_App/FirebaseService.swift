//
//  FirebaseService.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/28/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    static let shared = FirebaseService()
    var firebaseApiService: FirebaseAPIService?
    private init() {
        print("Wisk | Firebase Initialized")
        FirebaseApp.configure()
        self.firebaseApiService = FirebaseAPIService()
    }
}



