//
//  ClaimListRouter.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import UIKit

class ClaimListRouter: ClaimListRouterProtocol {
    static func createModule() -> UIViewController {
        let view = ClaimListViewController()
        let presenter = ClaimListPresenter()
        let interactor = ClaimListInteractor()
        let router = ClaimListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
