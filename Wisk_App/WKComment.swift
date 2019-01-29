//
//  WKUpdates.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/31/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class WKUpdates:
    Mappable,
    CustomStringConvertible
{
    var object_Id: Any?
    var active: Any?
    var city: Any?
    var latitude: Any?
    var longitude: Any?
    var name: Any?
    var state: Any?
    var concourses: Any?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        active <- map["active"]
        city <- map["city"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        name <- map["name"]
        state <- map["state"]
        concourses <- map["Concourses"]
    }
    
    func getAirportLocation() -> String? {
        guard
            let city = self.city as? String,
            let state = self.state as? String
            else {
                return nil
        }
        return city + ", " + state
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

class Concourse:
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
