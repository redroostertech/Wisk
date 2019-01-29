//
//  GoogleMapsService.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/28/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import GoogleMaps

class GoogleMapsService {
    static let shared = GoogleMapsService()
    private init() {
        print("Wisk | GoogleMaps Initialized")
        GMSServices.provideAPIKey(googleAPIKey)
    }
}
