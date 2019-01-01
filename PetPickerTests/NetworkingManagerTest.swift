//
//  PPApiServiceTest.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 12/29/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import PetPicker

class NetworkingManagerTest: XCTestCase {

    func testNetworkingManagerSingleton() {
        let service: Any = NetworkingManager.shared
        XCTAssert(((service as? NetworkingManager) != nil))
        
        let duplicate = NetworkingManager.shared
        XCTAssert(duplicate === service as! NetworkingManager)
    }
    
    func testItCanGetMatches() {
        // Depends on real API
        let exp = expectation(description: "Wait for real API response - should fail first time if server asleep")
        let nm = NetworkingManager.shared
//        nm.ppService = MockService()
        nm.getMatches(id: 2, completion: { (matches) in
            XCTAssert(matches.count == 2)
            if let match = matches.first {
                XCTAssert(match.id == 2)
                XCTAssert(match.name == "Bongo")
            } else {
                XCTAssert(false)
            }
            if let match = matches.last {
                XCTAssert(match.id == 4)
                XCTAssert(match.name == "Jimmy")
            }
            exp.fulfill()
        })

        waitForExpectations(timeout: 1, handler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }
    
    func testItCanGetPets() {
        // Depends on real API
        let exp = expectation(description: "Wait for real API response - should fail first time if server asleep")
        let nm = NetworkingManager.shared
        //        nm.ppService = MockService()
        nm.getPets(id: 3, completion: { (pets) in
            XCTAssert(pets.count == 7)
            if let pet = pets.first {
                XCTAssert(pet.id == 1)
                XCTAssert(pet.name == "Wanda")
                XCTAssert(pet.description == "heckin angery woofer wow such tempt fluffer corgo borking doggo such treat, heckin puggo very good spot woofer, such treat waggy wags he made many woofs noodle horse.")
            } else {
                XCTAssert(false)
            }
            if let pet = pets.last {
                XCTAssert(pet.id == 16)
                XCTAssert(pet.name == "Tuty")
                XCTAssert(pet.pic == "https://www.cesarsway.com/sites/newcesarsway/files/styles/large_article_preview/public/Cesars-Today-Top-Ten-Puppy-Tips.jpg?itok=T2AuVJHq")
            }
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }
    
    func testItCanLoginUser() {
        // Depends on real API
        let exp = expectation(description: "Wait for real API response - should fail first time if server asleep")
        let nm = NetworkingManager.shared
        nm.ppService = MockService()
        nm.loginUser(name: "steventyler", password: "123", completion: { (user) in
            XCTAssert(user.id == 3)
            XCTAssert(user.name == "steventyler")
            XCTAssert(user.description == "Gimme your puppies!")
            XCTAssert(user.role == "adopter")
            
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }
    
    func testItCanLoginOwner() {
        // Depends on real API
        let exp = expectation(description: "Wait for real API response - should fail first time if server asleep")
        let nm = NetworkingManager.shared
        //        nm.ppService = MockService()
        nm.loginUser(name: "puppyboi", password: "123", completion: { (user) in
            XCTAssert(user.id == 4)
            XCTAssert(user.name == "puppyboi")
            XCTAssert(user.description == "I like snakes!!!")
            XCTAssert(user.role == "owner")
            
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }}


import Alamofire

class MockService: PPService {
    
    func request(path: String, method: HTTPMethod, params: [String : Any]?, completion: @escaping (Any) -> Void) {
        
        completion(["id": 3, "name": "steventyler", "description": "Gimme your puppies!", "role": "adopter"])
    }
}
