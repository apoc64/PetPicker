//
//  Pet.swift
//  PetPicker
//
//  Created by Tyler Westlie  on 10/9/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation

class Pet {
    var id: Int!
    var name: String!
    var species: String!
    var description: String!
    var pic: String!
    var user_id: Int!
    
    init(data: [String: Any]) {
        id = data["id"] as? Int
        name = data["name"] as? String
        species = data["species"] as? String
        description = data["description"] as? String
        pic = data["pic"] as? String
        user_id = data["user_id"] as? Int
    }
}
