//
//  AuthService.swift
//  homestuff-SwiftUI
//
//  Created by Assistant on 25/01/25.
//

import Foundation

class AuthService: ObservableObject {
    private var baseURL: String {
        return EnvironmentManager.shared.baseURL
    }
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var userData: UserResponse?
    @Published var authToken: String?
    
    // MARK: - Login
    func login(email: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.login)") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            await MainActor.run {
                errorMessage = "Failed to encode request data"
                isLoading = false
            }
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                            self.authToken = tokenResponse.access_token
                            self.isAuthenticated = true
                            self.errorMessage = nil
                        } catch {
                            self.errorMessage = "Failed to decode response"
                        }
                    } else {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            self.errorMessage = errorResponse.detail
                        } catch {
                            self.errorMessage = "Login failed with status code: \(httpResponse.statusCode)"
                        }
                    }
                }
            }
            
            // Fetch user data after successful login (outside MainActor.run)
            if isAuthenticated {
                await fetchUserData()
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // MARK: - Register
    func register(name: String, email: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        let registerRequest = RegisterRequest(name: name, email: email, password: password)
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.register)") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(registerRequest)
        } catch {
            await MainActor.run {
                errorMessage = "Failed to encode request data"
                isLoading = false
            }
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                        do {
                            let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                            self.userData = userResponse
                            self.isAuthenticated = true
                            self.errorMessage = nil
                        } catch {
                            self.errorMessage = "Failed to decode response"
                        }
                    } else {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            self.errorMessage = errorResponse.detail
                        } catch {
                            self.errorMessage = "Registration failed with status code: \(httpResponse.statusCode)"
                        }
                    }
                }
            }
            
            // Auto login after successful registration (outside MainActor.run)
            if isAuthenticated {
                await login(email: email, password: password)
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // MARK: - Fetch User Data
    func fetchUserData() async {
        guard let token = authToken else { return }
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.userProfile)") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                            self.userData = userResponse
                        } catch {
                            self.errorMessage = "Failed to decode user data"
                        }
                    } else {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            self.errorMessage = errorResponse.detail
                        } catch {
                            self.errorMessage = "Failed to fetch user data"
                        }
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        isAuthenticated = false
        userData = nil
        authToken = nil
        errorMessage = nil
    }
} 
