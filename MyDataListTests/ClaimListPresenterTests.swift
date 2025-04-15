//
//  ClaimListPresenterTests.swift
//  MyDataListTests
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import XCTest
@testable import MyDataList

class ClaimListPresenterTests: XCTestCase {

    var presenter: ClaimListPresenter!
    var mockView: MockClaimListViewInput!
    var mockInteractor: MockClaimListInteractorInput!
    var mockRouter: MockClaimListRouter!

    override func setUp() {
        super.setUp()
        mockView = MockClaimListViewInput()
        mockInteractor = MockClaimListInteractorInput()
        mockRouter = MockClaimListRouter()
        presenter = ClaimListPresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewDidLoad_callsFetchClaims() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchClaimsCalled)
    }

    func testDidSearch_updatesViewWithFilteredClaims() {
        let claims = [
            Claim(userId: 1, id: 1, title: "Claim 1", body: "Description 1"),
            Claim(userId: 2, id: 2, title: "Claim 2", body: "Description 2")
        ]
        
        presenter.didFetchClaims(claims)

        presenter.didSearch(query: "Claim 1")

        XCTAssertTrue(mockView.showClaimsCalled)
        if let filteredClaims = mockView.claims {
            XCTAssertEqual(filteredClaims.count, 1)
            XCTAssertEqual(filteredClaims.first?.title, "Claim 1")
        } else {
            XCTFail("Expected claims to be set, but got nil")
        }
    }


    func testDidFilterByUser_updatesViewWithFilteredClaims() {
        let claims = [
            Claim(userId: 1, id: 1, title: "Claim 1", body: "Description 1"),
            Claim(userId: 2, id: 2, title: "Claim 2", body: "Description 2")
        ]
        
        presenter.didFetchClaims(claims)

        presenter.didFilterByUser(userId: 1)
        
        XCTAssertEqual(mockView.showClaimsCalled, true)
        XCTAssertEqual(mockView.claims?.count, 1)
        XCTAssertEqual(mockView.claims?.first?.userId, 1)
    }

}

class MockClaimListInteractorInput: ClaimListInteractorInput {
    var fetchClaimsCalled = false
    
    func fetchClaims() {
        fetchClaimsCalled = true
    }
    
    func searchClaims(query: String, allClaims: [Claim]) -> [Claim] {
        return allClaims.filter { $0.title.lowercased().contains(query.lowercased()) }
    }

    func filterClaimsByUser(userId: Int?, allClaims: [Claim]) -> [Claim] {
        guard let userId = userId else { return allClaims }
        return allClaims.filter { $0.userId == userId }
    }
}

class MockClaimListViewInput: ClaimListViewInput {
    var showClaimsCalled = false
    var claims: [Claim]?
    
    func showClaims(_ claims: [Claim]) {
        showClaimsCalled = true
        self.claims = claims
    }
    
    func showError(_ error: String) {
       
    }
}

class MockClaimListRouter: ClaimListRouterProtocol {
    static func createModule() -> UIViewController {
        return UIViewController()
    }
}
