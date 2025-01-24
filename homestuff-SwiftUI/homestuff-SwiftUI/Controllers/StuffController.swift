//
//  StuffController.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 23/01/25.
//

import Foundation

let currentDate = Date()
let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Stuffs.plist")

class StuffController: ObservableObject {
    @Published var stuff: [Stuff] = []
    
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
        let addedItem = Stuff(id: lastID! + 1, name: name, createDate: currentDate, expireDate: expire)
        stuff.append(addedItem)
        
        saveData()
    }
}
