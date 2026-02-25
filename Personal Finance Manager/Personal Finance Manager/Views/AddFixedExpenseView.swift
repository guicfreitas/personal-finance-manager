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
    @State private var category: ExpenseCategory = .other
    @State private var repeatsMonthly = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Fixed Expense") {
                    TextField("Title", text: $title)
                    CurrencyField(title: "Amount", value: $amount)
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases) { item in
                            Label(item.title, systemImage: item.systemImage)
                                .tag(item)
                        }
                    }
                    Toggle("Repeat Each Month", isOn: $repeatsMonthly)
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
                            amount: amount,
                            category: category,
                            repeatsMonthly: repeatsMonthly
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
