//
//  CategoriesService.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/29/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import Firebase

class CategoriesService {
    static let shared = CategoriesService()
    private var firebaseApiService: FirebaseAPIService!
    private var group = DispatchGroup()
    var categories: [WKCategory]?
    private init() {
        print("Wisk | Categories Service Initialized")
        self.firebaseApiService = FirebaseAPIService()
    }
    func retrieveAllCategories(completion: @escaping ([WKCategory]?) -> Void) {
        if self.categories == nil {
            self.performFirebaseRequest {
                (categories) in
                if let categories = categories {
                    completion(categories)
                } else {
                    print("Wisk | Error with retrieveAllCategories. No categories available")
                    completion(nil)
                }
            }
        } else {
            completion(self.categories!)
        }
    }
    func retrieveAllActiveCategories(completion: @escaping ([WKCategory]?) -> Void) {
        if self.categories == nil {
            self.performFirebaseRequest {
                (categories) in
                if let categories = categories {
                    completion(
                        categories.filter({
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
                self.categories!.filter({
                    ($0.active as? Bool) == true
                })
            )
        }
    }
    
    private func performFirebaseRequest(completion: @escaping ([WKCategory]?)-> Void) {
        self.firebaseApiService.performFirebaseApiRequest(atChild: "categories") {
            (data) in
            
            print(data)
            guard
                let categories = data,
                categories.count > 0
                else
            {
                print("Nil")
                completion(nil)
                return
            }
            
            var categoriesArray = [WKCategory]()
            
            for key in categories.keys {
                self.group.enter()
                guard
                    let categoryObject = categories[key] as? [String:Any],
                    let category = WKCategory(JSON: categoryObject) else
                {
                    completion(nil)
                    return
                }
                categoriesArray.append(category)
                self.group.leave()
            }
            self.group.notify(queue: .main, execute: {
                self.categories = categoriesArray
                completion(categoriesArray)
            })
        }
    }
}

