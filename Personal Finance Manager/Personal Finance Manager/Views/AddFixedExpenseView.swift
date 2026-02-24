//
//  AddFixedExpenseView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI
import SwiftData

struct AddFixedExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var amount = Decimal.zero

    var body: some View {
        NavigationStack {
            Form {
                Section("Fixed Expense") {
                    TextField("Title", text: $title)
                    CurrencyField(title: "Amount", value: $amount)
                }
            }
            .navigationTitle("New Fixed")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = FixedExpense(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            amount: amount
                        )
                        modelContext.insert(expense)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
