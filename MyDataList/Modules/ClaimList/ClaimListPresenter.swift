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
    private var datas: [User] = []
    private var mappedClaim: [MappedClaim] = []
    
    private var currentSearchQuery: String = ""
    private var currentFilterUserId: Int? = nil
    
    func mapClaimsToUserNames() -> [MappedClaim] {
        let topClaims = Array(allClaims.prefix(10))
        
        guard datas.count >= topClaims.count else {
            print("Jumlah user tidak cukup untuk mapping")
            return []
        }
        let mapped = topClaims.enumerated().map { index, claim in
            let userName = datas[index].name
            return MappedClaim(id: claim.id, title: claim.title, body: claim.body, userName: userName)
        }

        return mapped
    }




}

extension ClaimListPresenter: ClaimListViewOutput {
    func viewDidLoad() {
        interactor?.fetchClaims()
    }
    
    func fetchData() {
        interactor?.fetchData()
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
    func didFetchData(_ data: [User]) {
        self.datas = data
        self.mappedClaim = mapClaimsToUserNames()
        view?.showDatas(self.mappedClaim)
    }
    
    func didFailToFetchData(error: any Error) {
        view?.showError(error.localizedDescription)
    }
    
    func didFetchClaims(_ claims: [Claim]) {
        self.allClaims = claims
        self.filteredClaims = claims
        view?.showClaims(claims)
    }

    func didFailToFetchClaims(error: Error) {
        view?.showError(error.localizedDescription)
    }
}
