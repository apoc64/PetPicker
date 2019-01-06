//
//  SwipeViewControllerTest.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 1/6/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import PetPicker

class SwipeViewControllerTest: XCTestCase {
    
    var svc: SwipeViewController!

    override func setUp() {
        let nm = NetworkingManager.shared
        nm.ppService = MockService()
        let user = User(data: ["id": 3, "name": "bob", "role": "adopter"])
        user.setAsDefault()
        svc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SwipeViewControllerID") as! SwipeViewController)
    }

    func testSwipeVCGetsCurrentUserAndPetsOnViewLoad() {
        XCTAssertNil(svc.currentUser)
        _ = svc.view // calls viewDidLoad which loads user from default, gets pets
        XCTAssert(svc.currentUser?.id == 3)
        XCTAssert(svc.currentUser?.name == "bob")
        XCTAssert(svc.currentUser?.role == "adopter")
        // Get pet info from cards:
        XCTAssert(svc.cardName.text == "Wanda")
        XCTAssert(svc.bgCardName.text == "Bingo")
        // Like pet to advance cards (probably should be private)
        svc.likePet()
        XCTAssert(svc.cardName.text == "Bingo")
        XCTAssert(svc.bgCardName.text == "Tuty")
    }
}
