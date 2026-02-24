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
                CurrencyField(title: "Total Amount", value: $expense.totalAmount)
                CurrencyField(title: "Installment Value", value: $expense.installmentValue)
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
    }
}
