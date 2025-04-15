//
//  ClaimDetailPresenterTests.swift
//  MyDataListTests
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import XCTest
@testable import MyDataList

class ClaimDetailPresenterTests: XCTestCase {

    var presenter: ClaimDetailPresenter!
    var mockView: MockClaimDetailViewInput!
    var mockInteractor: MockClaimDetailInteractorInput!
    var mockRouter: MockClaimDetailRouter!

    override func setUp() {
        super.setUp()
        mockView = MockClaimDetailViewInput()
        mockInteractor = MockClaimDetailInteractorInput()
        mockRouter = MockClaimDetailRouter()
        
        let claim = Claim(userId: 1, id: 1, title: "Sample Claim", body: "Sample Body")
        presenter = ClaimDetailPresenter(claim: claim)
        
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

    func testViewDidLoad_callsShowClaimDetail() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockView.showClaimDetailCalled)
        XCTAssertEqual(mockView.claim?.title, "Sample Claim")
    }
    
    func testCreateModule_withClaim_returnsViewController() {
        let claim = Claim(userId: 1, id: 1, title: "Claim Detail", body: "Some Body")
        let viewController = ClaimDetailRouter.createModule(with: claim)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is ClaimDetailViewController)
    }
}

class MockClaimDetailViewInput: ClaimDetailViewInput {
    var showClaimDetailCalled = false
    var claim: Claim?
    
    func showClaimDetail(_ claim: Claim) {
        showClaimDetailCalled = true
        self.claim = claim
    }
}

class MockClaimDetailInteractorInput: ClaimDetailInteractorInput {

}

class MockClaimDetailRouter: ClaimDetailRouterInput {
    static func createModule(with claim: Claim) -> UIViewController {
        let view = ClaimDetailViewController()
        let presenter = ClaimDetailPresenter(claim: claim)
        let interactor = ClaimDetailInteractor()
        let router = ClaimDetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        return view
    }
}
