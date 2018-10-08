//
//  PetPickerTests.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 10/2/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import PetPicker

class PetPickerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitNewUser() {
        let data = ["id": 2, "name": "bob","key": "1234", "species_to_adopt": "dog", "description": "gimme puppers", "pic": "www.google.com/mypic.png"] as [String : Any]
        let user = User(data: data)
        
        XCTAssert(user.id == 2)
        XCTAssert(user.name == "bob")
        XCTAssert(user.description == "gimme puppers")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
