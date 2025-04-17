//
//  ClaimDetailRouter.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import UIKit

class ClaimDetailRouter: ClaimDetailRouterInput {
    static func createModule(with claim: MappedClaim) -> UIViewController {
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
