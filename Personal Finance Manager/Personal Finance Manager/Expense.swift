//
//  Expense.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 23/02/26.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var title: String
    var totalAmount: Decimal
    var installmentValue: Decimal
    var paidInstallments: Int
    var totalInstallments: Int
    var lastUpdated: Date
    var categoryRaw: String

    init(
        title: String,
        totalAmount: Decimal,
        installmentValue: Decimal,
        paidInstallments: Int,
        totalInstallments: Int,
        lastUpdated: Date = Date(),
        category: ExpenseCategory = .other
    ) {
        self.title = title
        self.totalAmount = totalAmount
        self.installmentValue = installmentValue
        self.paidInstallments = paidInstallments
        self.totalInstallments = totalInstallments
        self.lastUpdated = lastUpdated
        self.categoryRaw = category.rawValue
    }

    var remainingInstallments: Int {
        max(totalInstallments - paidInstallments, 0)
    }

    var remainingAmount: Decimal {
        installmentValue * Decimal(remainingInstallments)
    }

    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
}
