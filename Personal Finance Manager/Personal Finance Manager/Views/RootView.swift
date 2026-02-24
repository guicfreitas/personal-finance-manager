//
//  RootView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    enum Tab: Hashable {
        case expenses
        case budget
    }

    @Environment(\.modelContext) private var modelContext

    @State private var selectedTab: Tab = .expenses
    @State private var quickAddMessage: String?

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }
                .tag(Tab.expenses)

            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "chart.pie")
                }
                .tag(Tab.budget)
        }
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .alert("Quick Add", isPresented: Binding(
            get: { quickAddMessage != nil },
            set: { if !$0 { quickAddMessage = nil } }
        )) {
            Button("OK", role: .cancel) { quickAddMessage = nil }
        } message: {
            Text(quickAddMessage ?? "")
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard let link = QuickAddLink(url: url) else { return }
        if let identifier = link.identifier, hasExistingExpense(with: identifier) {
            quickAddMessage = "Already added."
            selectedTab = .budget
            return
        }
        let expense = MonthlyExpense(
            title: link.title,
            amount: link.amount,
            date: Date(),
            sourceId: link.identifier
        )
        modelContext.insert(expense)
        selectedTab = .budget
        quickAddMessage = "Added \(link.title)"
    }

    private func hasExistingExpense(with identifier: String) -> Bool {
        let predicate = #Predicate<MonthlyExpense> { expense in
            expense.sourceId == identifier
        }
        let descriptor = FetchDescriptor<MonthlyExpense>(predicate: predicate)
        return (try? modelContext.fetch(descriptor))?.isEmpty == false
    }
}
