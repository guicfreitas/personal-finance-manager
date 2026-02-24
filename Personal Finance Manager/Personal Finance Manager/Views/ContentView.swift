//
//  ContentView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 23/02/26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.lastUpdated, order: .reverse) private var expenses: [Expense]

    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    SummaryRow(label: "Total", value: totalAmount)
                    SummaryRow(label: "Installments (Open)", value: openInstallmentsTotal)
                    SummaryRow(label: "Remaining", value: remainingAmount)
                } header: {
                    Text("Summary")
                }

                Section {
                    ForEach(expenses) { expense in
                        NavigationLink {
                            ExpenseDetailView(expense: expense)
                        } label: {
                            ExpenseRow(expense: expense)
                        }
                    }
                    .onDelete(perform: deleteExpenses)
                } header: {
                    Text("Expenses")
                }
            }
            .navigationTitle("Personal Finance")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.isPresentingImporter = true
                    } label: {
                        Label("Import CSV", systemImage: "tray.and.arrow.down")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.isPresentingAdd = true
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isPresentingAdd) {
                AddExpenseView()
            }
            .fileImporter(
                isPresented: $viewModel.isPresentingImporter,
                allowedContentTypes: [.commaSeparatedText, .plainText]
            ) { result in
                switch result {
                case .success(let url):
                    viewModel.pendingImportURL = url
                    viewModel.isShowingImportOptions = true
                case .failure(let error):
                    viewModel.importMessage = error.localizedDescription
                    viewModel.isShowingImportResult = true
                }
            }
            .confirmationDialog(
                "Import CSV",
                isPresented: $viewModel.isShowingImportOptions,
                titleVisibility: .visible
            ) {
                Button("Replace Existing") {
                    viewModel.runImport(replaceExisting: true, modelContext: modelContext)
                }
                Button("Append") {
                    viewModel.runImport(replaceExisting: false, modelContext: modelContext)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Do you want to replace current expenses or append the CSV data?")
            }
            .alert("Import", isPresented: $viewModel.isShowingImportResult, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(viewModel.importMessage ?? "Import finished.")
            })
        }
    }

    private var totalAmount: Decimal {
        expenses.reduce(Decimal.zero) { $0 + $1.totalAmount }
    }

    private var remainingAmount: Decimal {
        expenses.reduce(Decimal.zero) { $0 + $1.remainingAmount }
    }

    private var openInstallmentsTotal: Decimal {
        expenses.reduce(Decimal.zero) { partial, expense in
            guard expense.remainingInstallments > 0 else { return partial }
            return partial + expense.installmentValue
        }
    }

    private func deleteExpenses(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(expenses[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Expense.self, inMemory: true)
}
