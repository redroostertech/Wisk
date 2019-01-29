//
//  WKConcourse.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/31/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class WKConcourse:
    Mappable,
    CustomStringConvertible
{
    var object_Id: Any?
    var name: Any?
    var latitude: Any?
    var longitude: Any?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["name"]
        latitude <- map["lat"]
        longitude <- map["lon"]
    }
    
    func getConcourseName() -> String {
        guard let name = self.name else {
            return "Empty"
        }
        return String(describing: name)
    }
    
    func getLongitudePoints() -> CLLocationDegrees {
        guard let longitude = self.longitude as? CLLocationDegrees else {
            return 0
        }
        return longitude
    }
    
    func getLatitudePoints() -> CLLocationDegrees {
        guard let latitude = self.latitude as? CLLocationDegrees else {
            return 0
        }
        return latitude
    }
}

