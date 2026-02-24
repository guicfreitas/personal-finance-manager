//
//  BudgetView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var settingsList: [BudgetSettings]
    @Query private var fixedExpenses: [FixedExpense]
    @Query(sort: \MonthlyExpense.date, order: .reverse) private var monthlyExpenses: [MonthlyExpense]
    @Query private var installments: [Expense]

    @StateObject private var viewModel = BudgetViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section("Budget") {
                    CurrencyField(title: "Monthly Budget", value: Binding(
                        get: { settings.baseBudget },
                        set: { settings.baseBudget = $0 }
                    ))
                    Text("Added from installments summary: \(installmentsOpenTotal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    BudgetProgressView(
                        total: totalBudget,
                        spent: totalSpent
                    )
                } header: {
                    Text("Progress")
                }

                Section("Fixed Expenses") {
                    ForEach(fixedExpenses) { expense in
                        HStack {
                            Text(expense.title)
                            Spacer()
                            Text(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                    }
                    .onDelete(perform: deleteFixedExpenses)

                    Button {
                        viewModel.isPresentingAddFixed = true
                    } label: {
                        Label("Add Fixed Expense", systemImage: "plus")
                    }
                }

                Section("Monthly Expenses") {
                    ForEach(monthlyExpenses) { expense in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(expense.title)
                            HStack {
                                Text(expense.date, style: .date)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            }
                            .font(.footnote)
                        }
                    }
                    .onDelete(perform: deleteMonthlyExpenses)

                    Button {
                        viewModel.isPresentingAddMonthly = true
                    } label: {
                        Label("Add Monthly Expense", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Budget")
            .onAppear {
                _ = settings
                viewModel.requestNotificationPermission()
                viewModel.scheduleBudgetWarningIfNeeded(
                    progress: budgetProgress,
                    month: settings.month,
                    year: settings.year
                )
            }
            .onChange(of: budgetProgress) { _, newValue in
                viewModel.scheduleBudgetWarningIfNeeded(
                    progress: newValue,
                    month: settings.month,
                    year: settings.year
                )
            }
            .sheet(isPresented: $viewModel.isPresentingAddFixed) {
                AddFixedExpenseView()
            }
            .sheet(isPresented: $viewModel.isPresentingAddMonthly) {
                AddMonthlyExpenseView()
            }
        }
        .dismissKeyboardOnTap()
    }

    private var settings: BudgetSettings {
        if let existing = settingsList.first {
            return existing
        }
        return viewModel.ensureSettings(modelContext: modelContext)
    }

    private var installmentsOpenTotal: Decimal {
        installments.reduce(Decimal.zero) { partial, expense in
            guard expense.remainingInstallments > 0 else { return partial }
            return partial + expense.installmentValue
        }
    }

    private var fixedTotal: Decimal {
        fixedExpenses.reduce(Decimal.zero) { $0 + $1.amount }
    }

    private var monthlyTotal: Decimal {
        monthlyExpenses.reduce(Decimal.zero) { $0 + $1.amount }
    }

    private var totalBudget: Decimal {
        settings.baseBudget + installmentsOpenTotal
    }

    private var totalSpent: Decimal {
        fixedTotal + monthlyTotal
    }

    private var budgetProgress: Double {
        let budget = NSDecimalNumber(decimal: totalBudget).doubleValue
        if budget <= 0 { return 0 }
        let spent = NSDecimalNumber(decimal: totalSpent).doubleValue
        return min(max(spent / budget, 0), 1)
    }

    private func deleteFixedExpenses(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(fixedExpenses[index])
        }
    }

    private func deleteMonthlyExpenses(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(monthlyExpenses[index])
        }
    }
}
