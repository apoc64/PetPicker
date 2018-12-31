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

}



//class MockService: PPApi {
//    override init() {
//        super.init
//    }
//    override func request(path: String, method: HTTPMethod, params: [String : Any]?, completion: @escaping (DataResponse<Any>) -> Void) {
//        print("Mock function run")
//    }
//}
