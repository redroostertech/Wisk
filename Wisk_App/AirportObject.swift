//
//  AirportObject.swift
//  Wisk_App
//
//  Created by Michael Westbrooks II on 9/4/17.
//  Copyright © 2017 redroostertechnologiesinc. All rights reserved.
//

import Foundation

class AirportObj {
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var name: String?
    var state: String?
    var concourses: [String:Any]?
    
    init(item: [String:Any]){
        if let conversionLat = item["latitude"] as? Int {
            latitude = Double(conversionLat)
        }
        if let conversionLon = item["longitude"] as? Int {
            longitude = Double(conversionLon)
        }
        if let conversionCity = item["city"] as? String {
            city = conversionCity
        }
        if let conversionName = item["name"] as? String {
            name = conversionName
        }
        if let conversionState = item["state"] as? String {
            state = conversionState
        }
        if let conversionConcourses = item["Concourses"] as? [String : Any] {
            /*for key in conversionConcourses.keys {
                guard let newobj : [String:Any] = conversionConcourses[key] as? [String:Any] else {
                    print("Error with type casting")
                    return
                }
                print(newobj)
            }*/
            concourses = conversionConcourses
        }
    }
}
