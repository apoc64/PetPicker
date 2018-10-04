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
    
    init(sendingVC: UIViewController) {
        sender = sendingVC // for async callbacks
    }
    
    func login(name: String, password: String) {
        let url = "\(baseUrl)/users?name=\(name)&password=\(password)"
        print(url)
        loginApiCall(url: url)
    }
    
    func loginApiCall(url: String)  {
        Alamofire.request(url).responseJSON { (response) in
            if let dataDict :Dictionary = response.value as? [String: Any] {
                self.newUser(data: dataDict)
            }
        }
    }
    
    func newUser(data: [String: Any]) {
        // check to see if successful, make a user
        print(data)
        if (data["message"] != nil) {
            print(data["message"]!)
        } else {
            let defaults = UserDefaults.standard
            defaults.set(data["id"], forKey: "user_id")
            // User(data: data)...
            let id = defaults.integer(forKey: "user_id")
            print(id)
            // what is prefered syntax?
            if let vc = sender as! ViewController! {
                vc.loginSegue() // sender performs segue
            }
        }
    }
}

