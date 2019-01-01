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
    var nm: NetworkingManager!
    
    override func setUp() {
        nm = NetworkingManager.shared
        nm.ppService = MockService()
    }

    func testNetworkingManagerSingleton() {
        let duplicate = NetworkingManager.shared
        XCTAssert(duplicate === nm, "Shared returns the same instance")
    }
    
    func testItCanGetMatches() {
        let exp = expectation(description: "Mock Async await")
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
        let exp = expectation(description: "Mock Async await")
        nm.getPets(id: 3, completion: { (pets) in
            XCTAssert(pets.count == 3)
            if let pet = pets.first {
                XCTAssert(pet.id == 1)
                XCTAssert(pet.name == "Wanda")
                XCTAssert(pet.description == "heckin angery woofer wow such tempt fluffer")
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
        let exp = expectation(description: "Mock Async await")
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
        let exp = expectation(description: "Mock Async await")
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

