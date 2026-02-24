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

    init(title: String, amount: Decimal, date: Date) {
        self.title = title
        self.amount = amount
        self.date = date
    }
}
