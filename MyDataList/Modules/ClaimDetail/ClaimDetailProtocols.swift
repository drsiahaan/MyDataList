//
//  ClaimDetailProtocols.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import UIKit

protocol ClaimDetailViewInput: AnyObject {
    func showClaimDetail(_ claim: Claim)
}

protocol ClaimDetailViewOutput: AnyObject {
    func viewDidLoad()
}

protocol ClaimDetailInteractorInput: AnyObject {}

protocol ClaimDetailRouterInput: AnyObject {
    static func createModule(with claim: Claim) -> UIViewController
}
