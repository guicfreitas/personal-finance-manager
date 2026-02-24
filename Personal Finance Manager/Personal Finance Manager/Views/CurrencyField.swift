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

    var body: some View {
        TextField(title, value: $value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            .keyboardType(.decimalPad)
    }
}
