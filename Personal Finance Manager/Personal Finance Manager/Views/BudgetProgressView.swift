//
//  BudgetProgressView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI

struct BudgetProgressView: View {
    let total: Decimal
    let spent: Decimal

    var body: some View {
        let totalValue = NSDecimalNumber(decimal: total).doubleValue
        let spentValue = NSDecimalNumber(decimal: spent).doubleValue
        let progress = totalValue > 0 ? min(max(spentValue / totalValue, 0), 1) : 0
        let remaining = totalValue - spentValue

        VStack(alignment: .leading, spacing: 8) {
            ProgressView(value: progress) {
                Text("Budget Used")
            }
            .tint(progress >= 0.8 ? .orange : .green)

            HStack {
                Text("Spent: \(spent, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                Spacer()
                Text("Remaining: \(Decimal(remaining), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }
}
