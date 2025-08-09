# Configuration Guide

## Environment Management

This app supports multiple environments for easy development and testing. The environment is configured directly in the code for simplicity.

### Available Environments

1. **Development** (`development`)
   - URL: `http://localhost:8090`
   - Use for local development

2. **Staging** (`staging`)
   - URL: `https://staging-api.homestuff.ekky.web.id`
   - Use for testing before production

3. **Production** (`production`)
   - URL: `https://api.homestuff.ekky.web.id`
   - Use for live production

### How to Switch Environments

**Simple Code-Based Configuration:**

1. Open `homestuff-SwiftUI/Config/Environment.swift`
2. Find the `EnvironmentConfig` struct:
```swift
struct EnvironmentConfig {
    static let currentEnvironment: AppEnvironment = .development
}
```
3. Change the value to your desired environment:
   - For development: `.development`
   - For staging: `.staging`
   - For production: `.production`

**Example:**
```swift
// Untuk development
static let currentEnvironment: AppEnvironment = .development

// Untuk staging
static let currentEnvironment: AppEnvironment = .staging

// Untuk production
static let currentEnvironment: AppEnvironment = .production
```

### Configuration Files

#### `AppConfig.swift`
Central configuration file containing:
- Environment URLs
- API endpoints
- App settings
- Feature flags
- Validation rules

#### `Environment.swift`
Environment management system:
- `AppEnvironment` enum with all available environments
- `EnvironmentConfig` struct for easy environment switching
- `EnvironmentManager` class for accessing current environment

### Adding New Environments

1. **Update `AppConfig.swift`**:
```swift
struct URLs {
    static let development = "http://localhost:8090"
    static let staging = "https://staging-api.homestuff.ekky.web.id"
    static let production = "https://api.homestuff.ekky.web.id"
    static let newEnvironment = "https://new-api.homestuff.ekky.web.id" // Add here
}
```

2. **Update `Environment.swift`**:
```swift
enum AppEnvironment: String, CaseIterable {
    case development = "development"
    case staging = "staging"
    case production = "production"
    case newEnvironment = "newEnvironment" // Add here
    
    var baseURL: String {
        switch self {
        case .development:
            return AppConfig.URLs.development
        case .staging:
            return AppConfig.URLs.staging
        case .production:
            return AppConfig.URLs.production
        case .newEnvironment: // Add here
            return AppConfig.URLs.newEnvironment
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
        case .newEnvironment: // Add here
            return "New Environment"
        }
    }
}
```

3. **Update `EnvironmentConfig`**:
```swift
struct EnvironmentConfig {
    static let currentEnvironment: AppEnvironment = .newEnvironment
}
```

### Best Practices

1. **Development**: Use `.development` for local development
2. **Staging**: Use `.staging` for testing
3. **Production**: Use `.production` for live app
4. **Testing**: Always test in staging before production
5. **Documentation**: Update this file when adding new environments

### Troubleshooting

#### Environment Not Switching
- Check if you've updated the correct file (`Environment.swift`)
- Clean build folder (Cmd+Shift+K)
- Restart Xcode

#### API Calls Failing
- Verify the environment URL is correct in `AppConfig.swift`
- Check network connectivity
- Ensure the API server is running

#### Build Issues
- Clean build folder (Cmd+Shift+K)
- Clean derived data
- Restart Xcode

### Quick Reference

**Current Environment Location:**
```
homestuff-SwiftUI/Config/Environment.swift
```

**Environment URLs Location:**
```
homestuff-SwiftUI/Config/AppConfig.swift
```

**To Switch Environment:**
1. Open `Environment.swift`
2. Change `EnvironmentConfig.currentEnvironment`
3. Build and run
