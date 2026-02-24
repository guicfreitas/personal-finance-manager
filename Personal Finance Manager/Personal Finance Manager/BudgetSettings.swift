//
//  BudgetSettings.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation
import SwiftData

@Model
final class BudgetSettings {
    var month: Int
    var year: Int
    var baseBudget: Decimal

    init(month: Int, year: Int, baseBudget: Decimal) {
        self.month = month
        self.year = year
        self.baseBudget = baseBudget
    }
}
