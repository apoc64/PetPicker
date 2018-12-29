//
//  MatchTest.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 12/29/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import PetPicker

class MatchTest: XCTestCase {

    func testInitNewMatch() {
        let data = ["id": 9, "name": "Steven Tyler likes Bingo", "status": "like", "adopter_id": 11, "pet_id": 7] as [String: Any]
        let match = Match(data: data)
        
        XCTAssert(match.id == 9)
        XCTAssert(match.name == "Steven Tyler likes Bingo")
        XCTAssert(match.status == "like")
        XCTAssert(match.adopter_id == 11)
        XCTAssert(match.pet_id == 7)
    }

}
