//
//  ClaimListProtocols.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import UIKit

// MARK: - View -> Presenter
protocol ClaimListViewOutput: AnyObject {
    func viewDidLoad()
    func didSearch(query: String)
    func didFilterByUser(userId: Int?)
}

// MARK: - Presenter -> View
protocol ClaimListViewInput: AnyObject {
    func showClaims(_ claims: [Claim])
    func showError(_ error: String)
}

// MARK: - Presenter -> Interactor
protocol ClaimListInteractorInput: AnyObject {
    func fetchClaims()
    func searchClaims(query: String, allClaims: [Claim]) -> [Claim]
    func filterClaimsByUser(userId: Int?, allClaims: [Claim]) -> [Claim]
}

// MARK: - Interactor -> Presenter
protocol ClaimListInteractorOutput: AnyObject {
    func didFetchClaims(_ claims: [Claim])
    func didFailToFetchClaims(error: Error)
}

// MARK: - Router
protocol ClaimListRouterProtocol {
    static func createModule() -> UIViewController
}

// MARK: - Service
protocol ClaimServiceProtocol {
    func fetchClaims(completion: @escaping (Result<[Claim], Error>) -> Void)
}
