//
//  PPApi.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/3/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation
import Alamofire

protocol PPService {
    func request(path: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (Any) -> Void)
}

// enum for HTTP methods...

class PPApi: PPService {
    // Shared instance Singleton:
    static let shared = PPApi()
    private init() {}
    
    private let baseUrl = "https://pet-picker-api.herokuapp.com/api/v1"
    
    func request(path: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (Any) -> Void) {
        // Add JWT logic here, add to url - AlamoFire doesn't support params in get requests
        let url = "\(baseUrl)\(path)"
        print("Making API call to: \(url), method: \(method), params: \(String(describing: params))")
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response: (DataResponse<Any>)) in
            if let responseDict = response.value as? [String: Any] {
                completion(responseDict)
            } else if let responseArray = response.value as? [Any] {
                completion(responseArray)
            } else {
                completion(["message": "invalid response"]) // error?
            }
        })
    }
}

