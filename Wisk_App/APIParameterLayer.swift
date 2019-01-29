//
//  APIParameterLayer.swift
//  Wisk
//
//  Created by Michael Westbrooks II on 5/13/18.
//  Copyright © 2018 MVPGurus. All rights reserved.
//

import Foundation
import Alamofire

class APIParameterLayer {
    static let shared = APIParameterLayer()
    private init() { }
    func setupParameter(withData data: [String:Any]) -> Parameters? {
        let data = data
        
        //  Add additional headers as needed
        //  ...
        
        return data
    }
}

