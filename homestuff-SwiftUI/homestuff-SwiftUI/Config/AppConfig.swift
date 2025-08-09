//
//  AppConfig.swift
//  homestuff-SwiftUI
//
//  Created by Assistant on 25/01/25.
//

import Foundation

struct AppConfig {
    
    // MARK: - Environment URLs
    struct URLs {
        static let development = "http://localhost:8090"
        static let staging = "https://staging-api.homestuff.ekky.web.id"
        static let production = "https://api.homestuff.ekky.web.id"
    }
    
    // MARK: - API Endpoints
    struct Endpoints {
        static let login = "/api/v1/auth/login"
        static let register = "/api/v1/auth/register"
        static let userProfile = "/api/v1/auth/me"
        static let items = "/api/v1/auth/items"
    }
    
    // MARK: - App Settings
    struct Settings {
        static let appName = "HomeStuff"
        static let appVersion = "1.0.0"
        static let buildNumber = "1"
        
        // Timeout settings
        static let requestTimeout: TimeInterval = 30
        static let retryAttempts = 3
        
        // Cache settings
        static let cacheExpiration: TimeInterval = 3600 // 1 hour
    }
    
    // MARK: - Feature Flags
    struct Features {
        static let enableDebugMenu = true
        static let enableEnvironmentSwitching = true
        static let enableAnalytics = false
    }
    
    // MARK: - Validation Rules
    struct Validation {
        static let minPasswordLength = 6
        static let maxPasswordLength = 50
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
}
