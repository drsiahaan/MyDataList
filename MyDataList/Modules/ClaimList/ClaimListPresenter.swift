//
//  ClaimListPresenter.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import Foundation

class ClaimListPresenter {
    weak var view: ClaimListViewInput?
    var interactor: ClaimListInteractorInput?
    var router: ClaimListRouterProtocol?

    private var allClaims: [Claim] = []
    private var filteredClaims: [Claim] = []

    private var currentSearchQuery: String = ""
    private var currentFilterUserId: Int? = nil
}

extension ClaimListPresenter: ClaimListViewOutput {
    func viewDidLoad() {
        interactor?.fetchClaims()
    }

    func didSearch(query: String) {
        currentSearchQuery = query
        filterClaims()
    }

    func didFilterByUser(userId: Int?) {
        currentFilterUserId = userId
        filterClaims()
    }

    private func filterClaims() {
        var filtered = allClaims

        if !currentSearchQuery.isEmpty {
            filtered = interactor?.searchClaims(query: currentSearchQuery, allClaims: filtered) ?? []
        }

        filtered = interactor?.filterClaimsByUser(userId: currentFilterUserId, allClaims: filtered) ?? []

        filteredClaims = filtered
        view?.showClaims(filteredClaims)
    }
}

extension ClaimListPresenter: ClaimListInteractorOutput {
    func didFetchClaims(_ claims: [Claim]) {
        self.allClaims = claims
        self.filteredClaims = claims
        view?.showClaims(claims)
    }

    func didFailToFetchClaims(error: Error) {
        view?.showError(error.localizedDescription)
    }
}
