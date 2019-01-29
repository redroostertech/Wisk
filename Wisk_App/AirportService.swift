//
//  AirportService.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/28/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import Firebase

class AirportsService {
    static let shared = AirportsService()
    private var firebaseApiService: FirebaseAPIService!
    private var group = DispatchGroup()
    var airports: [WKAirport]?
    private init() {
        print("Wisk | Airport Service Initialized")
        self.firebaseApiService = FirebaseAPIService()
    }
    
    func retrieveAllAirports(completion: @escaping ([WKAirport]?) -> Void) {
        if self.airports == nil {
            self.performFirebaseRequest {
                (airports) in
                if let airports = airports {
                    completion(airports)
                } else {
                    print("Wisk | Error with retrieveAllAirports. No airports available")
                    completion(nil)
                }
            }
        } else {
            completion(self.airports!)
        }
    }
    
    func retrieveAllActiveAirports(completion: @escaping ([WKAirport]?) -> Void){
        if self.airports == nil {
            self.performFirebaseRequest {
                (airports) in
                if let airports = airports {
                    completion(
                        airports.filter({
                            ($0.active as? Bool) == true
                        })
                    )
                } else {
                    print("Wisk | Error with retrieveAllActiveAirports. No airports available")
                    completion(nil)
                }
            }
        } else {
            completion(
                self.airports!.filter({
                    ($0.active as? Bool) == true
                })
            )
        }
    }
    
    private func performFirebaseRequest(completion: @escaping ([WKAirport]?)-> Void) {
        self.firebaseApiService.performFirebaseApiRequest(atChild: "airports") {
            (data) in
            guard
                let airports = data,
                airports.count > 0
                else
            {
                completion(nil)
                return
            }
            
            var airportsArray = [WKAirport]()
            
            for key in airports.keys {
                self.group.enter()
                guard
                    let airportObject = airports[key] as? [String:Any],
                    let airport = WKAirport(JSON: airportObject) else
                {
                    completion(nil)
                    return
                }
                airportsArray.append(airport)
                self.group.leave()
            }
            self.group.notify(queue: .main, execute: {
                self.airports = airportsArray
                completion(airportsArray)
            })
        }
    }
}
