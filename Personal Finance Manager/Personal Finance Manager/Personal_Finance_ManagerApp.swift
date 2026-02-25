//
//  Personal_Finance_ManagerApp.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 23/02/26.
//

import SwiftUI
import SwiftData

@main
struct Personal_Finance_ManagerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Expense.self,
            BudgetSettings.self,
            FixedExpense.self,
            MonthlyExpense.self,
        ])
        let modelConfiguration = ModelConfiguration("PersonalFinance", schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Reset store if schema changed and migration fails.
            let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            let modelContainerDir = appSupport.appendingPathComponent("ModelContainer")
            try? FileManager.default.removeItem(at: modelContainerDir)
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
