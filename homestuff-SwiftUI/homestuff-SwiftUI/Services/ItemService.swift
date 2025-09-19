//
//  ItemService.swift
//  homestuff-SwiftUI
//
//  Created by Assistant on 25/01/25.
//

import Foundation
import UIKit

class ItemService: ObservableObject {
    private var baseURL: String {
        return EnvironmentManager.shared.baseURL
    }
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var items: [Stuff] = []
    @Published var expiringItems: [Stuff] = []
    
    // MARK: - Create Item
    func createItem(name: String, expireDate: Date, photo: UIImage? = nil, authToken: String?) async -> Stuff? {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.items)") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add authorization header
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Handle multipart form data for photo upload
        if let photo = photo {
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            // Add text fields
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(name)\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"expire_date\"\r\n\r\n".data(using: .utf8)!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: expireDate)
            body.append("\(dateString)\r\n".data(using: .utf8)!)
            
            // Add photo
            if let imageData = photo.jpegData(compressionQuality: 0.8) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = body
        } else {
            // JSON request without photo
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let createRequest = CreateItemRequest(name: name, expireDate: expireDate)
            do {
                request.httpBody = try JSONEncoder().encode(createRequest)
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to encode request data"
                    isLoading = false
                }
                return nil
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                        do {
                            let itemResponse = try JSONDecoder().decode(ItemResponse.self, from: data)
                            let newItem = self.convertItemResponseToStuff(itemResponse)
                            self.items.append(newItem)
                            return
                        } catch {
                            self.errorMessage = "Failed to decode response"
                        }
                    } else {
                        do {
                            let errorResponse = try JSONDecoder().decode(ItemErrorResponse.self, from: data)
                            self.errorMessage = errorResponse.detail
                        } catch {
                            self.errorMessage = "Failed to create item with status code: \(httpResponse.statusCode)"
                        }
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isLoading = false
            }
        }
        
        return nil
    }
    
    // MARK: - Fetch All Items
    func fetchItems(authToken: String?) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.items)") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            let itemsResponse = try JSONDecoder().decode(ItemsResponse.self, from: data)
                            self.items = itemsResponse.items.map { self.convertItemResponseToStuff($0) }
                        } catch {
                            self.errorMessage = "Failed to decode response"
                        }
                    } else {
                        do {
                            let errorResponse = try JSONDecoder().decode(ItemErrorResponse.self, from: data)
                            self.errorMessage = errorResponse.detail
                        } catch {
                            self.errorMessage = "Failed to fetch items with status code: \(httpResponse.statusCode)"
                        }
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // MARK: - Fetch Expiring Items
    func fetchExpiringItems(authToken: String?) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.itemsExpiring)") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            let itemsResponse = try JSONDecoder().decode(ItemsResponse.self, from: data)
                            self.expiringItems = itemsResponse.items.map { self.convertItemResponseToStuff($0) }
                        } catch {
                            self.errorMessage = "Failed to decode response"
                        }
                    } else {
                        do {
                            let errorResponse = try JSONDecoder().decode(ItemErrorResponse.self, from: data)
                            self.errorMessage = errorResponse.detail
                        } catch {
                            self.errorMessage = "Failed to fetch expiring items with status code: \(httpResponse.statusCode)"
                        }
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // MARK: - Fetch Item Detail
    func fetchItemDetail(itemId: Int, authToken: String?) async -> Stuff? {
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.itemDetail.replacingOccurrences(of: "{item_id}", with: "\(itemId)"))") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
            }
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let itemResponse = try JSONDecoder().decode(ItemResponse.self, from: data)
                        return convertItemResponseToStuff(itemResponse)
                    } catch {
                        await MainActor.run {
                            errorMessage = "Failed to decode response"
                        }
                    }
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ItemErrorResponse.self, from: data)
                        await MainActor.run {
                            errorMessage = errorResponse.detail
                        }
                    } catch {
                        await MainActor.run {
                            errorMessage = "Failed to fetch item detail with status code: \(httpResponse.statusCode)"
                        }
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
            }
        }
        
        return nil
    }
    
    // MARK: - Update Item
    func updateItem(itemId: Int, name: String? = nil, expireDate: Date? = nil, authToken: String?) async -> Bool {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.itemDetail.replacingOccurrences(of: "{item_id}", with: "\(itemId)"))") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let updateRequest = UpdateItemRequest(name: name, expireDate: expireDate)
        do {
            request.httpBody = try JSONEncoder().encode(updateRequest)
        } catch {
            await MainActor.run {
                errorMessage = "Failed to encode request data"
                isLoading = false
            }
            return false
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Update the item in the local array
                        if let index = self.items.firstIndex(where: { $0.id == itemId }) {
                            if let name = name {
                                self.items[index] = Stuff(
                                    id: self.items[index].id,
                                    name: name,
                                    createDate: self.items[index].createDate,
                                    expireDate: expireDate ?? self.items[index].expireDate,
                                    photoUrl: self.items[index].photoUrl,
                                    userId: self.items[index].userId
                                )
                            }
                        }
                        return
                    } else {
                        do {
                            let errorResponse = try JSONDecoder().decode(ItemErrorResponse.self, from: data)
                            self.errorMessage = errorResponse.detail
                        } catch {
                            self.errorMessage = "Failed to update item with status code: \(httpResponse.statusCode)"
                        }
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isLoading = false
            }
        }
        
        return false
    }
    
    // MARK: - Delete Item
    func deleteItem(itemId: Int, authToken: String?) async -> Bool {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)\(AppConfig.Endpoints.itemDetail.replacingOccurrences(of: "{item_id}", with: "\(itemId)"))") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            await MainActor.run {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
                        // Remove the item from the local array
                        self.items.removeAll { $0.id == itemId }
                        return
                    } else {
                        self.errorMessage = "Failed to delete item with status code: \(httpResponse.statusCode)"
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isLoading = false
            }
        }
        
        return false
    }
    
    // MARK: - Helper Methods
    private func convertItemResponseToStuff(_ itemResponse: ItemResponse) -> Stuff {
        let createDate = parseDate(itemResponse.createDate)
        let expireDate = parseDate(itemResponse.expireDate)
        
        return Stuff(
            id: itemResponse.id,
            name: itemResponse.name,
            createDate: createDate,
            expireDate: expireDate,
            photoUrl: itemResponse.photoUrl,
            userId: itemResponse.userId
        )
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        
        // Try different date formats
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd"
        ]
        
        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        // If all formats fail, return current date
        return Date()
    }
}
