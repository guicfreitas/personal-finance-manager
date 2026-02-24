//
//  AddExpenseView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var totalAmount = Decimal.zero
    @State private var paidInstallments = 0
    @State private var totalInstallments = 1
    @State private var lastUpdated = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    CurrencyField(title: "Total Amount", value: $totalAmount, placeholder: "Total Amount")
                    HStack {
                        Text("Installment Value")
                        Spacer()
                        Text(installmentValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Installments") {
                    Stepper(value: $paidInstallments, in: 0...999) {
                        HStack {
                            Text("Paid Installments")
                            Spacer()
                            Text("\(paidInstallments)")
                        }
                    }
                    Stepper(value: $totalInstallments, in: 1...999) {
                        HStack {
                            Text("Total Installments")
                            Spacer()
                            Text("\(totalInstallments)")
                        }
                    }
                }

                Section("Last Updated") {
                    DatePicker("Updated", selection: $lastUpdated, displayedComponents: .date)
                }
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addExpense()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func addExpense() {
        let expense = Expense(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            totalAmount: totalAmount,
            installmentValue: installmentValue,
            paidInstallments: paidInstallments,
            totalInstallments: totalInstallments,
            lastUpdated: lastUpdated
        )
        modelContext.insert(expense)
    }

    private var installmentValue: Decimal {
        guard totalInstallments > 0 else { return .zero }
        return totalAmount / Decimal(totalInstallments)
    }
}
