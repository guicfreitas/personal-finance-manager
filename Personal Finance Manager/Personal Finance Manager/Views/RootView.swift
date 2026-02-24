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
        if let identifier = link.identifier, isDuplicate(identifier: identifier) {
            quickAddMessage = "Already added."
            selectedTab = .budget
            return
        }
        let expense = MonthlyExpense(
            title: link.title,
            amount: link.amount,
            date: Date()
        )
        modelContext.insert(expense)
        selectedTab = .budget
        quickAddMessage = "Added \(link.title)"
        if let identifier = link.identifier {
            markDuplicate(identifier: identifier)
        }
    }

    private func isDuplicate(identifier: String) -> Bool {
        UserDefaults.standard.bool(forKey: "quick-add-\(identifier)")
    }

    private func markDuplicate(identifier: String) {
        UserDefaults.standard.set(true, forKey: "quick-add-\(identifier)")
    }
}
