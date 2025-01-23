//
//  StuffController.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 23/01/25.
//

import Foundation

let currentDate = Date()
let nextMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: currentDate)

class StuffController: ObservableObject {
    @Published var stuff: [Stuff] = []
    
    func fetchData() {
        stuff = [
            Stuff(id: 1, name: "Taro", createDate: currentDate, expireDate: nextMonthDate!),
            Stuff(id: 2, name: "Tictac", createDate: currentDate, expireDate: nextMonthDate!),
            Stuff(id: 3, name: "Tanggo", createDate: currentDate, expireDate: nextMonthDate!),
        ]
    }
}
