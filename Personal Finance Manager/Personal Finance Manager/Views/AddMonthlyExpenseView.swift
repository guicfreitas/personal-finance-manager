//
//  AddMonthlyExpenseView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI
import SwiftData

struct AddMonthlyExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var amount = Decimal.zero
    @State private var date = Date()
    @State private var category: ExpenseCategory = .other

    var body: some View {
        NavigationStack {
            Form {
                Section("Monthly Expense") {
                    TextField("Title", text: $title)
                    CurrencyField(title: "Amount", value: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases) { item in
                            Label(item.title, systemImage: item.systemImage)
                                .tag(item)
                        }
                    }
                }
            }
            .navigationTitle("New Monthly")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = MonthlyExpense(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            amount: amount,
                            date: date,
                            category: category
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
