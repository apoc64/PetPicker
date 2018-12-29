//
//  UserTest.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 12/29/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import PetPicker

class UserTest: XCTestCase {

    func testInitNewUser() {
        let data = ["id": 2, "name": "bob","key": "1234", "species_to_adopt": "dog", "description": "gimme puppers", "pic": "www.google.com/mypic.png"] as [String : Any]
        let user = User(data: data)
        
        XCTAssert(user.id == 2)
        XCTAssert(user.name == "bob")
        XCTAssert(user.description == "gimme puppers")
    }

}
