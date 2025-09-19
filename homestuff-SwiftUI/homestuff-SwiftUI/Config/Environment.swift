//
//  Environment.swift
//  homestuff-SwiftUI
//
//  Created by Assistant on 25/01/25.
//

import Foundation

enum AppEnvironment: String, CaseIterable {
    case development = "development"
    case staging = "staging"
    case production = "production"
    
    var baseURL: String {
        switch self {
        case .development:
            return AppConfig.URLs.development
        case .staging:
            return AppConfig.URLs.staging
        case .production:
            return AppConfig.URLs.production
        }
    }
    
    var displayName: String {
        switch self {
        case .development:
            return "Development"
        case .staging:
            return "Staging"
        case .production:
            return "Production"
        }
    }
}

// MARK: - Environment Configuration
// Ubah nilai ini untuk switch environment
// Options: .development, .staging, .production
struct EnvironmentConfig {
    static let currentEnvironment: AppEnvironment = .production
}

class EnvironmentManager: ObservableObject {
    static let shared = EnvironmentManager()
    
    var currentEnvironment: AppEnvironment {
        return EnvironmentConfig.currentEnvironment
    }
    
    var baseURL: String {
        return currentEnvironment.baseURL
    }
    
    private init() {}
}
