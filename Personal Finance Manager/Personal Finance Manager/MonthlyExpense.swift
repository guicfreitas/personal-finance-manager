//
//  MonthlyExpense.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation
import SwiftData

@Model
final class MonthlyExpense {
    var title: String
    var amount: Decimal
    var date: Date
    var sourceId: String?
    var categoryRaw: String

    init(title: String, amount: Decimal, date: Date, sourceId: String? = nil, category: ExpenseCategory = .other) {
        self.title = title
        self.amount = amount
        self.date = date
        self.sourceId = sourceId
        self.categoryRaw = category.rawValue
    }

    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
}
