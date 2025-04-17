//
//  ClaimDetailProtocols.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import UIKit

protocol ClaimDetailViewInput: AnyObject {
    func showClaimDetail(_ claim: MappedClaim)
}

protocol ClaimDetailViewOutput: AnyObject {
    func viewDidLoad()
}

protocol ClaimDetailInteractorInput: AnyObject {}

protocol ClaimDetailRouterInput: AnyObject {
    static func createModule(with claim: MappedClaim) -> UIViewController
}
