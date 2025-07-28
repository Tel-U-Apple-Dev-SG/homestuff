//
//  AuthModel.swift
//  homestuff-SwiftUI
//
//  Created by Assistant on 25/01/25.
//

import Foundation

// MARK: - Login Request
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Register Request
struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

// MARK: - Login Response (Token)
struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
}

// MARK: - User Response
struct UserResponse: Codable {
    let id: Int
    let email: String
    let name: String
    let is_active: Bool
    let is_superuser: Bool
    let created_at: String
    let updated_at: String?
}

// MARK: - Error Response
struct ErrorResponse: Codable {
    let detail: String
} 