//
//  ExpenseCategory.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation

enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case food
    case transport
    case travel
    case shopping
    case bills
    case health
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .food: return "Food"
        case .transport: return "Transport"
        case .travel: return "Travel"
        case .shopping: return "Shopping"
        case .bills: return "Bills"
        case .health: return "Health"
        case .other: return "Other"
        }
    }

    var systemImage: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car"
        case .travel: return "airplane"
        case .shopping: return "bag"
        case .bills: return "doc.text"
        case .health: return "heart"
        case .other: return "tag"
        }
    }
}
