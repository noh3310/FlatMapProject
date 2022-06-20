//
//  Repos.swift
//  FlatMapProject
//
//  Created by 노건호 on 2022/06/20.
//

import Foundation

// MARK: - ReposResult
struct ReposResult: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repos]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Repos
struct Repos: Codable {
    let id: Int
    let nodeID, name, fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
    }
}
