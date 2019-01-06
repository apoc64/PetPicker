//
//  Pet.swift
//  PetPicker
//
//  Created by Tyler Westlie  on 10/9/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation

class Pet {
    var id = 0
    var name = ""
    var species = ""
    var description = ""
    var pic = ""
    var user_id = 0
    
    init(data: [String: Any]) {
        id = data["id"] as? Int ?? 0
        name = data["name"] as? String ?? ""
        species = data["species"] as? String ?? ""
        description = data["description"] as? String ?? ""
        pic = data["pic"] as? String ?? ""
        user_id = data["user_id"] as? Int ?? 0
    }
}
