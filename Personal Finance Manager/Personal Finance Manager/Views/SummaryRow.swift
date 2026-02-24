//
//  SummaryRow.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI

struct SummaryRow: View {
    let label: String
    let value: Decimal

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.headline)
        }
    }
}
