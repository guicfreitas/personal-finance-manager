//
//  ExpenseRow.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI

struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        let isFinished = expense.paidInstallments >= expense.totalInstallments

        VStack(alignment: .leading, spacing: 6) {
            Text(expense.title)
                .font(.headline)
                .foregroundStyle(isFinished ? .green : .primary)

            HStack {
                Text("Paid \(expense.paidInstallments)/\(expense.totalInstallments)")
                Spacer()
                Text(expense.installmentValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }
            .font(.subheadline)
            .foregroundStyle(isFinished ? .green : .secondary)

            HStack {
                Text("Remaining: \(expense.remainingInstallments)")
                Spacer()
                Text(expense.remainingAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }
            .font(.footnote)
            .foregroundStyle(isFinished ? .green : .secondary)
        }
    }
}
