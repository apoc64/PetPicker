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
    
    func login(name: String, password: String) {
        if let encodedName = urlSafe(string: name), let encodedPassword = urlSafe(string: password) {
            let url = "\(baseUrl)/users?name=\(encodedName)&password=\(encodedPassword)"
            loginApiCall(url: url)
        }
    }
    
    func urlSafe(string: String) -> String? { // adds percent signs for spaces
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    func loginApiCall(url: String)  {
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            if let dataDict :Dictionary = response.value as? [String: Any] {
                self.newUser(data: dataDict)
            }
        }
    }
    
    func createUserApi(data: [String: Any]) {
        let url = "\(baseUrl)/users"
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            if let dataDict :Dictionary = response.value as? [String: Any] {
                self.createUser(data: data, dataDict: dataDict)
            }
        }
    }
    
    func createUser(data: [String: Any], dataDict: [String: Any]) {
        let user = User(data: data["user"] as! [String : Any])
        user.id = dataDict["id"] as? Int
        print(user.name, user.description)
        print("THIS IS THE DATA: \(data)")
        user.setAsDefault()
        if let vc = self.sender as? NewUserViewController {
            vc.loginSegue(user: user)
        }
        print(dataDict)
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
    
    func newUser(data: [String: Any]) {
        // check to see if successful
        print(data)
        if (data["message"] != nil) {
            print(data["message"]!)
            // handle failed login
        } else {
            let user = User(data: data)
            user.setAsDefault()
            
            if let vc = sender as? ViewController {
                vc.loginSegue(user: user) // sender performs segue
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
}

