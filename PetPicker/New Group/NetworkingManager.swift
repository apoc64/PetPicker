//
//  NetworkingManager.swift
//  PetPicker
//
//  Created by Steven Schwedt on 12/30/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation

class NetworkingManager {
    // Shared instance Singleton:
    static let shared = NetworkingManager()
    var ppService: PPService // was private let - test
    private init() {
        ppService = PPApi.shared
    }
    
    // MARK: - User API methods
    func loginUser(name: String, password: String, completion: @escaping ((User) -> Void)) {
        guard let encodedName = urlSafe(string: name), let encodedPassword = urlSafe(string: password) else { return }
        let url = "/users?name=\(encodedName)&password=\(encodedPassword)"
        ppService.request(path: url, method: .get, params: nil, completion: { (response: (Any)) in
            self.userResponse(response: response, completion: completion)
        })
    }
    
    func createUser(data: [String: Any], completion: @escaping ((User) -> Void)) {
        ppService.request(path: "/users", method: .post, params: data, completion: { (response: (Any)) in
            self.userResponse(response: response, completion: completion)
        })
    }
    
    func updateUser(data: [String: Any], id: Int, completion: @escaping ((User) -> Void)) {
        ppService.request(path: "/users/\(id)", method: .patch, params: data, completion: { (response: (Any)) in
            self.userResponse(response: response, completion: completion)
        })
    }
    
    private func userResponse(response: Any, completion: @escaping ((User) -> Void)) {
        print("Recieved user API response data: \(response)")
        guard let dataDict :Dictionary = response as? [String: Any] else { return  }
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
    
    // MARK: - Get Pets API methods
    func getPets(id: Int, completion: @escaping (([Pet]) -> Void)) {
        let url = "/users/\(id)/pets"
        ppService.request(path: url, method: .get, params: nil, completion: { (response: (Any)) in
            self.getPetsResponse(response: response, completion: completion)
        })
    }
    
    private func getPetsResponse(response: Any, completion: @escaping (([Pet]) -> Void)) {
        print("Recieved get pets API response data: \(response)")
        guard let dataArray :Array = response as? [[String: Any]] else { return }
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
        ppService.request(path: "/users/\(id)/matches", method: .get, params: nil, completion: { (response: (Any)) in
            self.getMatchesResponse(response: response, completion: completion)
        })
    }
    
    private func getMatchesResponse(response: Any, completion: @escaping (([Match]) -> Void)) {
        print("Recieved get matches API response data: \(response)")
        guard let dataArray :Array = response as? [[String: Any]] else { return }
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
        ppService.request(path: "/users/\(user_id)/connections", method: .post, params: ["pet_id": pet_id], completion: { (response: (Any)) in
            self.swipeResponse(response: response, completion: completion)
        })
    }
    
    func nopePet(user_id: Int, pet_id: Int, completion: (() -> Void)?) {
        ppService.request(path: "/users/\(user_id)/connections", method: .delete, params: ["pet_id": pet_id], completion: { (response: (Any)) in
            self.swipeResponse(response: response, completion: completion)
        })
    }
    
    private func swipeResponse(response: Any, completion: (() -> Void)?) {
        print("Recieved swipt API response data: \(response)")
    }
    
    // MARK: - Helper Method
    private func urlSafe(string: String) -> String? { // adds percent signs for spaces
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}
