//
//  ClaimDetailPresenter.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import Foundation

class ClaimDetailPresenter {
    weak var view: ClaimDetailViewInput?
    var interactor: ClaimDetailInteractorInput?
    var router: ClaimDetailRouterInput?
    
    private let claim: Claim

    init(claim: Claim) {
        self.claim = claim
    }
}

extension ClaimDetailPresenter: ClaimDetailViewOutput {
    func viewDidLoad() {
        view?.showClaimDetail(claim)
    }
}
