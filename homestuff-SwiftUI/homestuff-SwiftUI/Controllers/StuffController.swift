//
//  StuffController.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 23/01/25.
//

import Foundation
import UIKit

let currentDate = Date()
let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Stuffs.plist")

class StuffController: ObservableObject {
    @Published var stuff: [Stuff] = []
    @Published var expiringItems: [Stuff] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let itemService = ItemService()
    
    // MARK: - Local Storage Methods (for backward compatibility)
    func fetchData() {
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                stuff = try decoder.decode([Stuff].self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(stuff)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
    }
    
    func createStuff(name: String, expire: Date) {
        let lastID = stuff.last?.id
        var currentID = 1
        if lastID != nil {
            currentID = lastID! + 1
        }
        let addedItem = Stuff(id: currentID, name: name, createDate: currentDate, expireDate: expire, photoUrl: nil, userId: nil)
        stuff.append(addedItem)
        
        saveData()
    }
    
    // MARK: - API Methods
    func fetchItemsFromAPI(authToken: String?) async {
        await itemService.fetchItems(authToken: authToken)
        
        await MainActor.run {
            self.stuff = itemService.items
            self.isLoading = itemService.isLoading
            self.errorMessage = itemService.errorMessage
        }
    }
    
    func fetchExpiringItemsFromAPI(authToken: String?) async {
        await itemService.fetchExpiringItems(authToken: authToken)
        
        await MainActor.run {
            self.expiringItems = itemService.expiringItems
            self.isLoading = itemService.isLoading
            self.errorMessage = itemService.errorMessage
        }
    }
    
    func createItemViaAPI(name: String, expireDate: Date, photo: UIImage? = nil, authToken: String?) async -> Stuff? {
        let newItem = await itemService.createItem(name: name, expireDate: expireDate, photo: photo, authToken: authToken)
        
        await MainActor.run {
            if let item = newItem {
                self.stuff.append(item)
            }
            self.isLoading = itemService.isLoading
            self.errorMessage = itemService.errorMessage
        }
        
        return newItem
    }
    
    func updateItemViaAPI(itemId: Int, name: String? = nil, expireDate: Date? = nil, authToken: String?) async -> Bool {
        let success = await itemService.updateItem(itemId: itemId, name: name, expireDate: expireDate, authToken: authToken)
        
        await MainActor.run {
            if success {
                // Update local array
                if let index = self.stuff.firstIndex(where: { $0.id == itemId }) {
                    if let name = name {
                        self.stuff[index] = Stuff(
                            id: self.stuff[index].id,
                            name: name,
                            createDate: self.stuff[index].createDate,
                            expireDate: expireDate ?? self.stuff[index].expireDate,
                            photoUrl: self.stuff[index].photoUrl,
                            userId: self.stuff[index].userId
                        )
                    }
                }
            }
            self.isLoading = itemService.isLoading
            self.errorMessage = itemService.errorMessage
        }
        
        return success
    }
    
    func deleteItemViaAPI(itemId: Int, authToken: String?) async -> Bool {
        let success = await itemService.deleteItem(itemId: itemId, authToken: authToken)
        
        await MainActor.run {
            if success {
                // Remove from local array
                self.stuff.removeAll { $0.id == itemId }
            }
            self.isLoading = itemService.isLoading
            self.errorMessage = itemService.errorMessage
        }
        
        return success
    }
    
    func fetchItemDetailFromAPI(itemId: Int, authToken: String?) async -> Stuff? {
        return await itemService.fetchItemDetail(itemId: itemId, authToken: authToken)
    }
}
