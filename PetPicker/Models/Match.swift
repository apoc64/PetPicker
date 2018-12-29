//
//  Match.swift
//  PetPicker
//
//  Created by Tyler Westlie  on 10/10/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation

class Match {
    var id: Int!
    var name: String!
    var status: String!
    var adopter_id: Int!
    var pet_id: Int!
    
    init(data: [String: Any]) {
        id = data["id"] as? Int
        name = data["name"] as? String
        status = data["status"] as? String
        adopter_id = data["adopter_id"] as? Int
        pet_id = data["pet_id"] as? Int
    }
}
