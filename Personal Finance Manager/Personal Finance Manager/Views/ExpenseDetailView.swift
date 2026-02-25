//
//  ExpenseDetailView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI
import SwiftData

struct ExpenseDetailView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var expense: Expense

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $expense.title)
                CurrencyField(title: "Total Amount", value: $expense.totalAmount, placeholder: "Total Amount")
                Picker("Category", selection: $expense.category) {
                    ForEach(ExpenseCategory.allCases) { item in
                        Label(item.title, systemImage: item.systemImage)
                            .tag(item)
                    }
                }
                HStack {
                    Text("Installment Value")
                    Spacer()
                    Text(expense.installmentValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(.secondary)
                }
            }

            Section("Installments") {
                Stepper(value: $expense.paidInstallments, in: 0...999) {
                    HStack {
                        Text("Paid Installments")
                        Spacer()
                        Text("\(expense.paidInstallments)")
                    }
                }
                Stepper(value: $expense.totalInstallments, in: 1...999) {
                    HStack {
                        Text("Total Installments")
                        Spacer()
                        Text("\(expense.totalInstallments)")
                    }
                }
                .onChange(of: expense.totalInstallments) { _, _ in
                    recalculateInstallmentValue()
                }
                HStack {
                    Text("Remaining Installments")
                    Spacer()
                    Text("\(expense.remainingInstallments)")
                }
                HStack {
                    Text("Remaining Amount")
                    Spacer()
                    Text(expense.remainingAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }

            Section("Last Updated") {
                DatePicker("Updated", selection: $expense.lastUpdated, displayedComponents: .date)
            }

            Section {
                Button(role: .destructive) {
                    modelContext.delete(expense)
                } label: {
                    Label("Delete Expense", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Expense")
        .onChange(of: expense.totalAmount) { _, _ in
            recalculateInstallmentValue()
        }
    }

    private func recalculateInstallmentValue() {
        guard expense.totalInstallments > 0 else {
            expense.installmentValue = .zero
            return
        }
        expense.installmentValue = expense.totalAmount / Decimal(expense.totalInstallments)
    }
}
