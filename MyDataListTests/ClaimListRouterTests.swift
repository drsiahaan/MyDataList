//
//  ClaimListRouterTests.swift
//  MyDataListTests
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import XCTest
@testable import MyDataList

class ClaimListRouterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCreateModule_returnsViewController() {
        let viewController = ClaimListRouter.createModule()
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is ClaimListViewController)
    }
}
