//
//  StuffModel.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 23/01/25.
//

import Foundation

struct Stuff: Identifiable, Codable {
    let id: Int
    let name: String
    let createDate: Date
    let expireDate: Date
}
