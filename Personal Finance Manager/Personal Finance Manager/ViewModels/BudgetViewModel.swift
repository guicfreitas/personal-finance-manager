//
//  BudgetViewModel.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation
import SwiftData
import Combine
import UserNotifications

@MainActor
final class BudgetViewModel: ObservableObject {
    @Published var isPresentingAddFixed = false
    @Published var isPresentingAddMonthly = false
    @Published var didRequestNotifications = false
    @Published var isShowingClearNonRepeatingConfirmation = false

    func ensureSettings(modelContext: ModelContext) -> BudgetSettings {
        if let existing = try? modelContext.fetch(FetchDescriptor<BudgetSettings>()).first {
            return existing
        }
        let now = Date()
        let calendar = Calendar.current
        let settings = BudgetSettings(
            month: calendar.component(.month, from: now),
            year: calendar.component(.year, from: now),
            baseBudget: .zero
        )
        modelContext.insert(settings)
        return settings
    }

    func requestNotificationPermission() {
        guard !didRequestNotifications else { return }
        didRequestNotifications = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func scheduleBudgetWarningIfNeeded(progress: Double, month: Int, year: Int) {
        guard progress >= 0.8 else { return }
        let key = "budget-warning-\(year)-\(month)"
        if UserDefaults.standard.bool(forKey: key) {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Budget Alert"
        content.body = "You used 80% of your monthly budget."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: key,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
        UserDefaults.standard.set(true, forKey: key)
    }
}
