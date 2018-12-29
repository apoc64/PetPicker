//
//  PetTests.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 12/29/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import PetPicker

class PetTests: XCTestCase {

    func testInitNewPet() {
        let data = ["id": 3, "name": "Bingo", "species": "dog", "description": "Bark Bark", "pic": "http://www.google.com/dogpic", "user_id": 7] as [String: Any]
        let pet = Pet(data: data)
        
        XCTAssert(pet.id == 3)
        XCTAssert(pet.name == "Bingo")
        XCTAssert(pet.species == "dog")
        XCTAssert(pet.user_id == 7)
    }
}
