//
//  Sequence+Extensions.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 5/28/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == [String: Any] {
    
    func values(of key: String) -> [Any]? {
        var result: [Any] = []
        for value in self {
            let val = value
            for (k, v) in val {
                if k == key {
                    result.append(v)
                    break
                }
            }
        }
        return result.isEmpty ? nil : result
    }
}
