//
//  NetworkingManager.swift
//  PetPicker
//
//  Created by Steven Schwedt on 12/30/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation
import Alamofire // for DataResponse - handle in service later

class NetworkingManager {
    // Shared instance Singleton:
    static let shared = NetworkingManager()
    private let ppService: PPApi
    private init() {
        ppService = PPApi.shared
    }
    
    // MARK: - User API methods
    func loginUser(name: String, password: String, completion: @escaping ((User) -> Void)) {
        guard let encodedName = urlSafe(string: name), let encodedPassword = urlSafe(string: password) else { return }
        let url = "/users?name=\(encodedName)&password=\(encodedPassword)"
        ppService.request(path: url, method: .get, params: nil, completion: { (response: (DataResponse<Any>)) in
            self.userResponse(data: response, completion: completion)
        })
    }
    
    func createUser(data: [String: Any], completion: @escaping ((User) -> Void)) {
        ppService.request(path: "/users", method: .post, params: data, completion: { (response: (DataResponse<Any>)) in
            self.userResponse(data: response, completion: completion)
        })
    }
    
    func updateUser(data: [String: Any], id: Int, completion: @escaping ((User) -> Void)) {
        ppService.request(path: "/users/\(id)", method: .patch, params: data, completion: { (response: (DataResponse<Any>)) in
            self.userResponse(data: response, completion: completion)
        })
    }
    
    private func userResponse(data: DataResponse<Any>, completion: @escaping ((User) -> Void)) {
        print("Recieved user API response data: \(data)")
        guard let dataDict :Dictionary = data.value as? [String: Any] else { return  }
        if let user = self.createUser(data: dataDict) {
            completion(user)
        }
    }
    
    private func createUser(data: [String: Any]) -> User? {
        if (data["message"] != nil) {
            print("Failed to create user. Message: \(data["message"]!)")
            return nil
        } else {
            let user = User(data: data)
            user.setAsDefault()
            return user
        }
    }
    
    // MARK: - Get Pets API methods ... Response to [String: Any]?
    func getPets(id: Int, completion: @escaping (([Pet]) -> Void)) {
        let url = "/users/\(id)/pets"
        ppService.request(path: url, method: .get, params: nil, completion: { (response: (DataResponse<Any>)) in
            self.getPetsResponse(data: response, completion: completion)
        })
    }
    
    private func getPetsResponse(data: DataResponse<Any>, completion: @escaping (([Pet]) -> Void)) {
        print("Recieved get pets API response data: \(data)")
        guard let dataArray :Array = data.value as? [[String: Any]] else { return }
        if let pets = self.createPets(data: dataArray) {
            completion(pets)
        }
    }
    
    private func createPets(data: [[String: Any]]) -> [Pet]? {
        let pets = data.map({
            (value: [String: Any]) -> Pet in
            return Pet(data: value)
        })
        return pets
    }
    
    // MARK: - Get matches API methods
    func getMatches(id: Int, completion: @escaping (([Match]) -> Void)) {
        ppService.request(path: "/users/\(id)/matches", method: .get, params: nil, completion: { (response: (DataResponse<Any>)) in
            self.getMatchesResponse(data: response, completion: completion)
        })
    }
    
    private func getMatchesResponse(data: DataResponse<Any>, completion: @escaping (([Match]) -> Void)) {
        print("Recieved get matches API response data: \(data)")
        guard let dataArray :Array = data.value as? [[String: Any]] else { return }
        if let matches = self.createMatches(data: dataArray) {
            completion(matches)
        }
    }
    
    private func createMatches(data: [[String: Any]]) -> [Match]? {
        let matches = data.map({
            (value: [String: Any]) -> Match in
            return Match(data: value)
        })
        return matches
    }
    
    // MARK: - Pet swiping API Methods
    func likePet(user_id: Int, pet_id: Int, completion: (() -> Void)?) {
        ppService.request(path: "/users/\(user_id)/connections", method: .post, params: ["pet_id": pet_id], completion: { (response: (DataResponse<Any>)) in
            self.swipeResponse(data: response, completion: completion)
        })
    }
    
    func nopePet(user_id: Int, pet_id: Int, completion: (() -> Void)?) {
        ppService.request(path: "/users/\(user_id)/connections", method: .delete, params: ["pet_id": pet_id], completion: { (response: (DataResponse<Any>)) in
            self.swipeResponse(data: response, completion: completion)
        })
    }
    
    private func swipeResponse(data: DataResponse<Any>, completion: (() -> Void)?) {
        print("Recieved swipt API response data: \(data)")
    }
    
    // MARK: - Helper Method
    private func urlSafe(string: String) -> String? { // adds percent signs for spaces
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}
