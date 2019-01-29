//
//  LocationModel.swift
//  Wisk
//
//  Created by Michael Westbrooks II on 12/13/15.
//  Copyright © 2015 RedRooster Technologies Inc. All rights reserved.
//

import Foundation
import CoreLocation

enum TravelModes: Int {
	case driving
	case walking
	case bicycling
}

open class LocationModel {
	
	// Handle Geocoding
	let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
	let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
 
    var lookupAddressResults: [String:Any]!
	var fetchedFormattedAddress: String!
	var fetchedAddressLongitude: Double!
	var fetchedAddressLatitude: Double!

	var selectedRoute: [String:Any]!
	var overviewPolyline: [String:Any]!
	var originCoordinate: CLLocationCoordinate2D!
	var destinationCoordinate: CLLocationCoordinate2D!
	var originAddress: String!
	var destinationAddress: String!
	var totalDistanceInMeters: UInt = 0
	var totalDistance: String!
	var totalDurationInSeconds: UInt = 0
	var totalDuration: String!
	
	var travelMode = TravelModes.walking
	
	func geocodeAddress(_ address: String!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
		if let lookupAddress = address {
			var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
			geocodeURLString = geocodeURLString.addingPercentEscapes(using: String.Encoding.utf8)!
			
			let geocodeURL = URL(string: geocodeURLString)
			DispatchQueue.main.async(execute: { () -> Void in
				let geocodingResultsData = try? Data(contentsOf: geocodeURL!)
				
				let error: NSError?
                let dictionary: [String:Any]!
				do {
                    dictionary = try JSONSerialization.jsonObject(with: geocodingResultsData!, options:  JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    
					let status = dictionary["status"] as! String
					
					if status == "OK" {
                        let allResults = dictionary["results"] as! [[String:Any]]
                        self.lookupAddressResults = allResults[0] as [String:Any]
						
						// Keep the most important values.
						self.fetchedFormattedAddress = self.lookupAddressResults["formatted_address"] as! String
						let geometry = self.lookupAddressResults["geometry"] as! [String:Any]
                        
						self.fetchedAddressLongitude = ((geometry["location"] as! [String:Any])["lng"] as! NSNumber).doubleValue
						self.fetchedAddressLatitude = ((geometry["location"] as! [String:Any])["lat"] as! NSNumber).doubleValue
						
						completionHandler(status, true)
					}
					else {
						completionHandler(status, false)
					}
				} catch {
					print(error)
					completionHandler("", false)
				}
			})
		} else {
			completionHandler("No valid address.", false)
		}
	}
	
	//	Handle Directions
	
	func getDirections(_ origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
		
		if let originLocation = origin {
			
			if let destinationLocation = destination {
				
				var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation //+ "&waypoints=optimize:true"
				
				directionsURLString = directionsURLString.addingPercentEscapes(using: String.Encoding.utf8)!
				
				let directionsURL = URL(string: directionsURLString)
				
				DispatchQueue.main.async(execute: { () -> Void in
					let directionsData = try? Data(contentsOf: directionsURL!)
					
                    let error: NSError?
                    let dictionary: [String:Any]!
					do {
						dictionary = try JSONSerialization.jsonObject(with: directionsData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
						let status = dictionary["status"] as! String
						
						if status == "OK" {
							
                            self.selectedRoute = (dictionary["routes"] as! [[String:Any]])[0]
							
							self.overviewPolyline = self.selectedRoute["overview_polyline"] as! [String:Any]
							
							let legs = self.selectedRoute["legs"] as! [[String:Any]]
                            
							let startLocationDictionary = legs[0]["start_location"] as! [String:Any]
							self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
							
							let endLocationDictionary = legs[legs.count - 1]["end_location"] as! [String:Any]
							
							self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
							
							self.originAddress = legs[0]["start_address"] as! String
							
							self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
							
							self.calculateTotalDistanceAndDuration()
							
							completionHandler(status, true)
						} else {
							completionHandler(status, false)
						}
					}
					catch {
						print(error)
							completionHandler("", false)
					}
				})
			} else {
				completionHandler("Destination is nil.", false)
			}
		}
		else {
			completionHandler("Origin is nil", false)
		}
	}
	
	func calculateTotalDistanceAndDuration() {
		let legs = self.selectedRoute["legs"] as! [[String:Any]]
		
		totalDistanceInMeters = 0
		totalDurationInSeconds = 0
		
		for leg in legs {
			totalDistanceInMeters += (leg["distance"] as! [String:Any])["value"] as! UInt
			totalDurationInSeconds += (leg["duration"] as! [String:Any])["value"] as! UInt
		}
		
		
		let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
		totalDistance = "Total Distance: \(distanceInKilometers) Km"
		
		
		let mins = totalDurationInSeconds / 60
		let hours = mins / 60
		let days = hours / 24
		let remainingHours = hours % 24
		let remainingMins = mins % 60
		let remainingSecs = totalDurationInSeconds % 60
		
		totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
	}

}
