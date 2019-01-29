//
//  GMSMarker.swift
//  Wisk
//
//  Created by Michael Westbrooks II on 12/13/15.
//  Copyright © 2015 RedRooster Technologies Inc. All rights reserved.
//

import Foundation
import GoogleMaps

class PlaceMarker: GMSMarker {
	// 1
	let place: GooglePlace
 
	// 2
	init(place: GooglePlace) {
		self.place = place
		super.init()
		
		position = place.coordinate
		icon = UIImage(named: place.placeType+"_pin")
		groundAnchor = CGPoint(x: 0.5, y: 1)
		appearAnimation = .pop
	}
}
