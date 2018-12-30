//
//  PPApi.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/3/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation
import Alamofire

class PPApi {
    // Shared instance Singleton:
    static let shared = PPApi()
    private init() {}
    
    private let baseUrl = "https://pet-picker-api.herokuapp.com/api/v1"
    
    // All actual API calls should use this method: - Move to service class to mock
    func request(path: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (DataResponse<Any>) -> Void) {
        // Add JWT logic here, add to url - AlamoFire doesn't support params in get requests
        let url = "\(baseUrl)\(path)"
        print("Making API call to: \(url), method: \(method), params: \(String(describing: params))")
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: completion)
        // Parse DataResponse and pass back Swift [String: Any] or Any?
    }
}

