//
//  PPApiServiceTest.swift
//  PetPickerTests
//
//  Created by Steven Schwedt on 12/29/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import PetPicker

class PPApiServiceTest: XCTestCase {

    func testPPApiSingleton() {
        let service: Any = PPApi.shared // Shared returns a singleton
        XCTAssert(((service as? PPApi) != nil))
        
        let duplicate = PPApi.shared // shared returns the same object
        XCTAssert(duplicate === service as! PPApi)
    }

}
