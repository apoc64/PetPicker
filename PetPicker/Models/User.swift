//
//  User.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/3/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation

class User {
    var id: Int!
    var name: String!
    var key: String? // is null in seeds?
    var speciesToAdopt: String!
    var description: String!
    var pic: String!
    
    init(data: [String: Any]) {
        id = data["id"] as? Int
        name = data["name"] as? String
        key = data["key"] as? String
        speciesToAdopt = data["species_to_adopt"] as? String
        description = data["dascription"] as? String
        pic = data["pic"] as? String
    }
    
    func setAsDefault() {
        // store key?
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: "user_id")
    }
    
    class func getUserFromDefault() -> User {
        let defaults = UserDefaults.standard
        let id = defaults.integer(forKey: "user_id")
        let user = User(data: ["id": id])
        return user
    }
}
