//
//  APIService.swift
//  Wisk
//
//  Created by Michael Westbrooks II on 5/13/18.
//  Copyright © 2018 MVPGurus. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    private let baseURL: String!
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    func getBaseURL() -> String {
        return self.baseURL
    }
    func performGetRequest(endpoint: String, parameters: Parameters? = nil, apiKey api: String, andAccessKey access: String, completion: @escaping (String?, Error?) -> Void) {
        let urlString = self.baseURL + endpoint
        guard let url = URL(string: urlString) else {
            print("Wisk | Error creating URL")
            return
        }
        let headers: [String: String] = [
            "wsc-api-key": api,
            "wsc-access-key": access,
            "Content-Type": "application/json"
        ]
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers
        Alamofire.request(request).responseString {
            response in
            if let error = response.error {
                completion(nil, error)
            } else {
                guard let value = response.result.value else {
                    return completion(nil, Errors.JSONResponseError)
                }
                completion(value.trimmingCharacters(in: .whitespacesAndNewlines), nil)
            }
        }
    }
    func performPostRequest(endpoint: String, parameters: Parameters? = nil, body: [String:String]? = nil, apiKey: String, accessKey: String, completion: @escaping (String?, Error?) -> Void) {
        let urlString = self.baseURL + endpoint
        guard let url = URL(string: urlString) else {
            print("Wisk | Error creating URL")
            return
        }
        let headers: [String: String] = [
            "wsc-api-key": apiKey,
            "wsc-access-key": accessKey,
            "Content-Type": "application/json"
        ]
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        // request.httpBody = body
        Alamofire.request(request).responseString {
            response in
            if let error = response.error {
                completion(nil, error)
            } else {
                guard let value = response.result.value else {
                    return completion(nil, Errors.JSONResponseError)
                }
                completion(value.trimmingCharacters(in: .whitespacesAndNewlines), nil)
            }
        }
    }
}
