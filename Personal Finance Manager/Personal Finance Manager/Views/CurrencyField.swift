//
//  CurrencyField.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI

struct CurrencyField: View {
    let title: String
    @Binding var value: Decimal

    @State private var text: String = ""
    @State private var isUpdating = false
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(title, text: $text)
            .keyboardType(.numberPad)
            .focused($isFocused)
            .onAppear {
                if text.isEmpty {
                    text = formatDecimal(value)
                }
            }
            .onChange(of: text) { _, newValue in
                guard !isUpdating else { return }
                let digits = newValue.filter { $0.isNumber }
                let cents = Decimal(string: digits) ?? .zero
                let newValueDecimal = cents / 100
                value = newValueDecimal

                let formatted = formatDecimal(newValueDecimal)
                if formatted != newValue {
                    isUpdating = true
                    text = formatted
                    isUpdating = false
                }
            }
            .onChange(of: value) { _, newValue in
                guard !isFocused else { return }
                let formatted = formatDecimal(newValue)
                if formatted != text {
                    isUpdating = true
                    text = formatted
                    isUpdating = false
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                        let formatted = formatDecimal(value)
                        if formatted != text {
                            isUpdating = true
                            text = formatted
                            isUpdating = false
                        }
                    }
                }
            }
    }

    private func formatDecimal(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "0,00"
    }
}
