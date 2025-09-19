//
//  StuffModel.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 23/01/25.
//

import Foundation

// MARK: - Item Model
struct Stuff: Identifiable, Codable {
    let id: Int
    let name: String
    let createDate: Date
    let expireDate: Date
    let photoUrl: String?
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createDate = "create_date"
        case expireDate = "expire_date"
        case photoUrl = "photo_url"
        case userId = "user_id"
    }
}

// MARK: - Item Request Models
struct CreateItemRequest: Codable {
    let name: String
    let expireDate: Date
    
    enum CodingKeys: String, CodingKey {
        case name
        case expireDate = "expire_date"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: expireDate)
        try container.encode(dateString, forKey: .expireDate)
    }
}

struct UpdateItemRequest: Codable {
    let name: String?
    let expireDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case name
        case expireDate = "expire_date"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let name = name {
            try container.encode(name, forKey: .name)
        }
        
        if let expireDate = expireDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: expireDate)
            try container.encode(dateString, forKey: .expireDate)
        }
    }
}

// MARK: - Item Response Models
struct ItemResponse: Codable {
    let id: Int
    let name: String
    let createDate: String
    let expireDate: String
    let photoUrl: String?
    let userId: Int
}

struct ItemsResponse: Codable {
    let items: [ItemResponse]
    let total: Int
    let page: Int
    let size: Int
}

// MARK: - Error Response
struct ItemErrorResponse: Codable {
    let detail: String
}
