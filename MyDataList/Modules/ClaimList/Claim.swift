//
//  Claim.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import Foundation

struct Claim: Equatable, Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    static func ==(lhs: Claim, rhs: Claim) -> Bool {
        return lhs.userId == rhs.userId &&
               lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.body == rhs.body
    }
}
