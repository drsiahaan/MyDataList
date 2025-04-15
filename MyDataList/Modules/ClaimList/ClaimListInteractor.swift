//
//  ClaimListInteractor.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import Foundation

class ClaimListInteractor: ClaimListInteractorInput {
    var presenter: ClaimListInteractorOutput?
    var claimService: ClaimServiceProtocol = ClaimService()

    func fetchClaims() {
        claimService.fetchClaims { [weak self] result in
            switch result {
            case .success(let claims):
                self?.presenter?.didFetchClaims(claims)
            case .failure(let error):
                self?.presenter?.didFailToFetchClaims(error: error)
            }
        }
    }

    func searchClaims(query: String, allClaims: [Claim]) -> [Claim] {
        return allClaims.filter { $0.title.lowercased().contains(query.lowercased()) || $0.body.lowercased().contains(query.lowercased()) }
    }

    func filterClaimsByUser(userId: Int?, allClaims: [Claim]) -> [Claim] {
        guard let userId = userId else { return allClaims }
        return allClaims.filter { $0.userId == userId }
    }
}
