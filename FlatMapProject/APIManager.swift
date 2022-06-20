//
//  APIManager.swift
//  FlatMapProject
//
//  Created by 노건호 on 2022/06/20.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class APIManager {
    
    func apiCall(_ str: String) -> Observable<[Repos]> {
        
        let parameters: Parameters = [
            "q": str
        ]
        
        return RxAlamofire.requestData(.get, URL(string: "https://api.github.com/search/repositories")!, parameters: parameters)
            .map { (response, data) in
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ReposResult.self, from: data)
                    return result.items
                } catch {
                    return []
                }
            }
    }
}
