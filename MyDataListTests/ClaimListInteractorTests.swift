//
//  ClaimListInteractorTests.swift
//  MyDataListTests
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import XCTest
@testable import MyDataList

class ClaimListInteractorTests: XCTestCase {

    var interactor: ClaimListInteractor!
    var mockPresenter: MockClaimListInteractorOutput!
    var mockClaimService: MockClaimService!

    override func setUp() {
        super.setUp()
        mockClaimService = MockClaimService()
        mockPresenter = MockClaimListInteractorOutput()
        interactor = ClaimListInteractor()
        interactor.presenter = mockPresenter
        interactor.claimService = mockClaimService
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockClaimService = nil
        super.tearDown()
    }

    func testFetchClaims_callsPresenterWithClaims() {
        let mockClaims = [Claim(userId: 1, id: 1, title: "Claim 1", body: "Description 1")]
        mockClaimService.mockClaims = mockClaims

        interactor.fetchClaims()

        XCTAssertTrue(mockPresenter.didFetchClaimsCalled)
        XCTAssertEqual(mockPresenter.claims, mockClaims)
    }

    func testSearchClaims() {
        let claims = [
            Claim(userId: 1, id: 1, title: "Claim 1", body: "Description 1"),
            Claim(userId: 2, id: 2, title: "Claim 2", body: "Description 2")
        ]
        let query = "Claim 1"
        
        let result = interactor.searchClaims(query: query, allClaims: claims)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Claim 1")
    }

    func testFilterClaimsByUser() {
        let claims = [
            Claim(userId: 1, id: 1, title: "Claim 1", body: "Description 1"),
            Claim(userId: 2, id: 2, title: "Claim 2", body: "Description 2")
        ]
        
        let result = interactor.filterClaimsByUser(userId: 1, allClaims: claims)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.userId, 1)
    }
}

class MockClaimService: ClaimServiceProtocol {
    var mockClaims: [Claim] = []
    
    func fetchClaims(completion: @escaping (Result<[Claim], Error>) -> Void) {
        completion(.success(mockClaims))
    }
}

class MockClaimListInteractorOutput: ClaimListInteractorOutput {
    var didFetchClaimsCalled = false
    var claims: [Claim] = []
    
    func didFetchClaims(_ claims: [Claim]) {
        didFetchClaimsCalled = true
        self.claims = claims
    }
    
    func didFailToFetchClaims(error: Error) {

    }
}
