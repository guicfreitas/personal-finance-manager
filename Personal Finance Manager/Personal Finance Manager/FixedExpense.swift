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

    init(title: String, amount: Decimal) {
        self.title = title
        self.amount = amount
    }
}
