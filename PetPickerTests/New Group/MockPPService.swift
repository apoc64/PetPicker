//
//  MockPPService.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 12/31/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import Foundation
import Alamofire
@testable import PetPicker

class MockService: PPService {
    
    func request(path: String, method: HTTPMethod, params: [String : Any]?, completion: @escaping (Any) -> Void) {
        
        switch path {
        case "/users?name=steventyler&password=123":
            completion(["id": 3, "name": "steventyler", "description": "Gimme your puppies!", "role": "adopter"])
        case "/users?name=puppyboi&password=123":
            completion(["id": 4, "name": "puppyboi", "description": "I like snakes!!!", "role": "owner"])
        case "/users":
            print("create user") // .post implement mock
        case "/users/3":
            print("update user") // .patch
        case "/users/3/pets":
            completion([["id": 1, "name": "Wanda", "description": "heckin angery woofer wow such tempt fluffer"],["id": 3, "name": "Bingo"],["id": 16, "name": "Tuty", "pic": "https://www.cesarsway.com/sites/newcesarsway/files/styles/large_article_preview/public/Cesars-Today-Top-Ten-Puppy-Tips.jpg?itok=T2AuVJHq"]])
        // Implement Swiping
        case "/users/2/matches":
            completion([["id": 2, "name": "Bongo"],["id": 4, "name": "Jimmy"]])
        default:
            print("Mock service path switch fell through")
        }
        
    }
}
