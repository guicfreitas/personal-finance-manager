//
//  FixedExpense.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation
import SwiftData

@Model
final class FixedExpense {
    var title: String
    var amount: Decimal
    var categoryRaw: String
    var repeatsMonthly: Bool

    init(title: String, amount: Decimal, category: ExpenseCategory = .other, repeatsMonthly: Bool = true) {
        self.title = title
        self.amount = amount
        self.categoryRaw = category.rawValue
        self.repeatsMonthly = repeatsMonthly
    }

    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
}
