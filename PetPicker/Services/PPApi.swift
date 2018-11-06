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
    private let baseUrl = "https://pet-picker-api.herokuapp.com/api/v1"
    private var sender: UIViewController!
    private var pets: [Pet] = []
    
    init(sendingVC: UIViewController) {
        sender = sendingVC // for async callbacks
    }
    
    private func apiCall(path: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (DataResponse<Any>) -> Void) {
        let url = "\(baseUrl)\(path)"
        print("Making API call to: \(url), method: \(method), params: \(String(describing: params))")
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: completion)
    }
    
    func login(name: String, password: String) {
        if let encodedName = urlSafe(string: name), let encodedPassword = urlSafe(string: password) {
            let url = "/users?name=\(encodedName)&password=\(encodedPassword)"
            apiCall(path: url, method: .get, params: nil, completion: loginUserCompletion)
        }
    }
    
    private lazy var loginUserCompletion: (DataResponse<Any>) -> Void  = { (response: (DataResponse<Any>)) in
        print("Completing login user api call")
        if let dataDict :Dictionary = response.value as? [String: Any] {
            print("About to create new logged in user with data: \(dataDict)")
            self.newUser(data: dataDict)
        }
    }
    
    func createUserApi(data: [String: Any]) {
//        let url = "\(baseUrl)/users"
        apiCall(path: "/users", method: .post, params: data, completion: loginUserCompletion)
        
//        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: nil).responseJSON {
//            (response) in
//            if let dataDict :Dictionary = response.value as? [String: Any] {
//                self.createUser(data: data, dataDict: dataDict)
//            }
//        }
    }
    
//    private lazy var createUserCompletion: (DataResponse<Any>) -> Void  = { (response: (DataResponse<Any>)) in
//        print("Completing new user api call")
//        if let dataDict :Dictionary = response.value as? [String: Any] {
//            print("About to create new user with data: \(dataDict)")
//            self.newUser(data: dataDict)
//        }
//    }
    
    func updateUserApi(data: [String: Any], id: Int) {
        let url = "\(baseUrl)/users/\(id)"
        Alamofire.request(url, method: .patch, parameters: data, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            if let dataDict :Dictionary = response.value as? [String: Any] {
                self.createUser(data: data, dataDict: dataDict)
            }
        }
    }
    
    func createUser(data: [String: Any], dataDict: [String: Any]) {
        let user = User(data: data["user"] as! [String : Any])
        if let id = dataDict["id"] as? Int {
            user.id = id
            print(user.name, user.description)
            print("THIS IS THE DATA: \(data)")
            user.setAsDefault()
            if let vc = self.sender as? NewUserViewController {
                vc.loginSegue(user: user)
            }
            print(dataDict)
        }
    }
    
    func getPets(id: Int) {
        let url = "\(baseUrl)/users/\(id)/pets"
        Alamofire.request(url).responseJSON { (response) in
            if let dataArray :Array = response.value as? [[String: Any]] {
                self.newPets(data: dataArray)
            }
        }
    }
    
    func newPets(data: [[String: Any]]) {
        let pets = data.map({
            (value: [String: Any]) -> Pet in
            return Pet(data: value)
        })
        if let vc = sender as? SwipeViewController {
            vc.addPets(newPets: pets) // sender performs segue
        }
    }
    
    func getMatches(id: Int) {
        let url = "\(baseUrl)/users/\(id)/matches"
        Alamofire.request(url).responseJSON { (response) in
            if let dataArray :Array = response.value as? [[String: Any]] {
                self.newMatches(data: dataArray)
                print(dataArray)
            }
        }
    }
    
    func newMatches(data: [[String: Any]]) {
        let matches = data.map({
            (value: [String: Any]) -> Match in
            return Match(data: value)
        })
        if let vc = sender as? MatchesTableViewController {
            vc.addMatches(matches: matches)
        }
    }
    
    // Used for logging in or creating new user:
    func newUser(data: [String: Any]) {
        print("User data: \(data)")
        if (data["message"] != nil) { // if unsuccessful
            print(data["message"]!)
            // handle failed login
        } else { // set successful action
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
        }
    }
    
    func likePet(user_id: Int, pet_id: Int) {
        let url = "\(baseUrl)/users/\(user_id)/connections"
        Alamofire.request(url, method: .post, parameters: ["pet_id": pet_id], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let dataDict :Dictionary = response.value as? [String: Any] {
                print(dataDict)
            }
        }
    }
    
    func nopePet(user_id: Int, pet_id: Int) {
        let url = "\(baseUrl)/users/\(user_id)/connections"
        Alamofire.request(url, method: .delete, parameters: ["pet_id": pet_id], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let dataDict :Dictionary = response.value as? [String: Any] {
                print(dataDict)
            }
        }
    }
    
    private func urlSafe(string: String) -> String? { // adds percent signs for spaces
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}

