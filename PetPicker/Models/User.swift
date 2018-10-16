//
//  User.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/3/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation

class User {
    var id = 0
    var name = ""
    var key = ""
    var speciesToAdopt = ""
    var description = ""
    var pic = ""
    var role = ""
    
    init(data: [String: Any]) {
        id = data["id"] as? Int ?? 0
        name = data["name"] as? String ?? ""
        key = data["key"] as? String ?? ""
        speciesToAdopt = data["species_to_adopt"] as? String ?? ""
        description = data["description"] as? String ?? ""
        pic = data["pic"] as? String ?? ""
        role = data["role"] as? String ?? ""
    }
    
    func setAsDefault() {
        let defaults = UserDefaults.standard
        let userData = ["id": id, "name": name, "description": description, "pic": pic, "role": role, "sepcies_to_adopt": speciesToAdopt, "key": key] as [String : Any]
        defaults.set(userData, forKey: "user")
    }
    
    class func getUserFromDefault() -> User {
        let defaults = UserDefaults.standard
        if let userInfo = defaults.dictionary(forKey: "user") {
            let user = User(data: userInfo )
            return user
        }
        return User(data: ["id": 0])
    }
}
