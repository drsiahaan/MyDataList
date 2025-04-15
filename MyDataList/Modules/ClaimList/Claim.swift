//
//  Claim.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import Foundation

struct Claim: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
