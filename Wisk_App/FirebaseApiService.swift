//
//  FirebaseApiService.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/28/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAPIService {
    private var firebaseDbRef: DatabaseReference!
    init() {
        print("Wisk | FirebaseAPI Initialized")
        self.firebaseDbRef = Database.database().reference()
    }
    func performFirebaseApiRequest(atChild child: String, completion: @escaping([String:Any]?) -> Void) {
        self.firebaseDbRef = self.firebaseDbRef.child(child)
        self.firebaseDbRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard
                let item = snapshot.value as? [String: Any] else {
                    print(snapshot.value)
                    print("snapshot children count = ", snapshot.childrenCount)
                    print("NIL")
                    return completion(nil)
            }
            completion(item)
        })
    }
}
