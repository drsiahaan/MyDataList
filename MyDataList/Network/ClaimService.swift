//
//  ClaimService.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import Alamofire

class ClaimService: ClaimServiceProtocol {
    func fetchClaims(completion: @escaping (Result<[Claim], Error>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let claims = try JSONDecoder().decode([Claim].self, from: data)
                    completion(.success(claims))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
