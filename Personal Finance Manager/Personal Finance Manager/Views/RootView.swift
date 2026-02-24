//
//  RootView.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }

            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "chart.pie")
                }
        }
    }
}
