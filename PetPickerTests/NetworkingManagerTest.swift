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
        let exp = expectation(description: "Wait for real API response")
        NetworkingManager.shared.getMatches(id: 2, completion: { (matches) in
            XCTAssert(matches.count == 2)
            if let match = matches.first {
                XCTAssert(match.id == 2)
                XCTAssert(match.name == "Bongo")
            } else {
                XCTAssert(false)
            }
            exp.fulfill()
        })

        waitForExpectations(timeout: 1, handler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }

}
