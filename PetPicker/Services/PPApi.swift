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
    let baseUrl = "https://pet-picker-api.herokuapp.com/api/v1"
    var sender: UIViewController!
    var pets: [Pet]!
    
    init(sendingVC: UIViewController) {
        sender = sendingVC // for async callbacks
    }
    
    func login(name: String, password: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(encodedName!)
        let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(encodedPassword!)
        let url = "\(baseUrl)/users?name=\(encodedName!)&password=\(encodedPassword!)"
        loginApiCall(url: url)
    }
    
    func loginApiCall(url: String)  {
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            if let dataDict :Dictionary = response.value as? [String: Any] {
                self.newUser(data: dataDict)
            }
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

