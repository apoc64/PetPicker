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
}

