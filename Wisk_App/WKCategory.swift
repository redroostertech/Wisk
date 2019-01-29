//
//  WKCategory.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/29/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class WKCategory:
    Mappable,
    CustomStringConvertible
{
    var object_Id: Any?
    var active: Any?
    var name: Any?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        active <- map["active"]
        name <- map["name"]
    }
    
    func getCategoryName() -> String {
        guard let name = self.name else {
            return ""
        }
        return String(describing: name)
    }
}

