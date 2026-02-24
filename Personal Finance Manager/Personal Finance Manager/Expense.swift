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

    init(
        title: String,
        totalAmount: Decimal,
        installmentValue: Decimal,
        paidInstallments: Int,
        totalInstallments: Int,
        lastUpdated: Date = Date()
    ) {
        self.title = title
        self.totalAmount = totalAmount
        self.installmentValue = installmentValue
        self.paidInstallments = paidInstallments
        self.totalInstallments = totalInstallments
        self.lastUpdated = lastUpdated
    }

    var remainingInstallments: Int {
        max(totalInstallments - paidInstallments, 0)
    }

    var remainingAmount: Decimal {
        installmentValue * Decimal(remainingInstallments)
    }
}
