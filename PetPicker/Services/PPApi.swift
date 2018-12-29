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
    static let shared = PPApi()
    
    private let baseUrl = "https://pet-picker-api.herokuapp.com/api/v1"
    private var sender: UIViewController?
    private var pets: [Pet] = []
    
    private init() { // sendingVC: UIViewController
//        sender = sendingVC // for async callbacks
    }
    
    // All actual API calls should use this method:
    private func apiCall(path: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (DataResponse<Any>) -> Void) {
        // Add JWT logic here, add to url - AlamoFire doesn't support params in get requests
        let url = "\(baseUrl)\(path)"
        print("Making API call to: \(url), method: \(method), params: \(String(describing: params))")
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: completion)
    }
    
    // MARK: - User API methods
    func login(name: String, password: String, sender: UIViewController) { // From home screen VC
        if let encodedName = urlSafe(string: name), let encodedPassword = urlSafe(string: password) {
            self.sender = sender
            let url = "/users?name=\(encodedName)&password=\(encodedPassword)"
            apiCall(path: url, method: .get, params: nil, completion: loginUserCompletion)
        }
    }
    
    func createUserApi(data: [String: Any], sender: UIViewController) { // From NewUserVC
        self.sender = sender
        apiCall(path: "/users", method: .post, params: data, completion: loginUserCompletion)
    }
    
    func updateUserApi(data: [String: Any], id: Int, sender: UIViewController) { // From ProfileVC
        self.sender = sender
        apiCall(path: "/users/\(id)", method: .patch, params: data, completion: loginUserCompletion)
    }
    
    // Completion handler for logging in, creating, or updating user:
    private lazy var loginUserCompletion: (DataResponse<Any>) -> Void  = { (response: (DataResponse<Any>)) in
        print("Completing login user api call")
        if let dataDict :Dictionary = response.value as? [String: Any] {
            print("About to create new logged in user with data: \(dataDict)")
            self.newUser(data: dataDict)
        }
    }
    // Used for logging in, creating, or updating user:
    private func newUser(data: [String: Any]) {
        print("About to create user data: \(data)")
        if (data["message"] != nil) { // if unsuccessful:
            print(data["message"]!)
        } else { // set successful action:
            let user = User(data: data)
            user.setAsDefault()
            // Logging in:
            if let vc = sender as? ViewController {
                vc.loginSegue(user: user) // sender performs segue
            }
            // Creating new:
            if let vc = self.sender as? NewUserViewController {
                vc.loginSegue(user: user)
            }
            // Why does this work without profile vc?
        }
    }
    
    // MARK: - Get Pets API methods
    func getPets(id: Int, sender: UIViewController) {
        let url = "/users/\(id)/pets"
        self.sender = sender
        apiCall(path: url, method: .get, params: nil, completion: getPetsCompletion)
    }
    
    private lazy var getPetsCompletion: (DataResponse<Any>) -> Void  = { (response: (DataResponse<Any>)) in
        print("Completing get pets api call")
        if let dataArray :Array = response.value as? [[String: Any]] {
            print("About to create new pets with data: \(dataArray)")
            self.newPets(data: dataArray)
        }
    }
    
    private func newPets(data: [[String: Any]]) {
        let pets = data.map({
            (value: [String: Any]) -> Pet in
            return Pet(data: value)
        })
        if let vc = sender as? SwipeViewController {
            vc.addPets(newPets: pets) // sender adds pets to vc array
        }
    }
    
    // MARK: - Get matches API methods
    func getMatches(id: Int, sender: UIViewController) {
        self.sender = sender
        apiCall(path: "/users/\(id)/matches", method: .get, params: nil, completion: getMatchesCompletion)
    }
    
    private lazy var getMatchesCompletion: (DataResponse<Any>) -> Void  = { (response: (DataResponse<Any>)) in
        print("Completing get matches api call")
        if let dataArray :Array = response.value as? [[String: Any]] {
            print("About to create new matches with data: \(dataArray)")
            self.newMatches(data: dataArray)
        }
    }
    
    private func newMatches(data: [[String: Any]]) {
        let matches = data.map({
            (value: [String: Any]) -> Match in
            return Match(data: value)
        })
        if let vc = sender as? MatchesTableViewController {
            vc.addMatches(matches: matches)
        }
    }
    
    // MARK: - Pet swiping API Methods
    func likePet(user_id: Int, pet_id: Int, sender: UIViewController) {
        self.sender = sender
        apiCall(path: "/users/\(user_id)/connections", method: .post, params: ["pet_id": pet_id], completion: swipeCompletion)
    }
    
    func nopePet(user_id: Int, pet_id: Int, sender: UIViewController) {
        self.sender = sender
        apiCall(path: "/users/\(user_id)/connections", method: .delete, params: ["pet_id": pet_id], completion: swipeCompletion)
    }
    
    private lazy var swipeCompletion: (DataResponse<Any>) -> Void  = { (response: (DataResponse<Any>)) in
        print("Completing get matches api call")
        if let dataDict :Dictionary = response.value as? [String: Any] {
            print("Swipe response: \(dataDict)")
        }
    }
    
    // MARK: - Helper Method
    private func urlSafe(string: String) -> String? { // adds percent signs for spaces
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}

