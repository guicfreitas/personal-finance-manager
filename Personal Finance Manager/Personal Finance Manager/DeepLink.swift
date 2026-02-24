//
//  DeepLink.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation

struct QuickAddLink {
    let title: String
    let amount: Decimal
    let identifier: String?

    init?(url: URL) {
        guard url.scheme == "personalfinance" else { return nil }
        guard url.host == "quick-add" else { return nil }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        let items = components.queryItems ?? []
        guard let title = items.first(where: { $0.name == "title" })?.value,
              let amountString = items.first(where: { $0.name == "amount" })?.value else {
            return nil
        }
        let identifier = items.first(where: { $0.name == "id" })?.value

        let trimmedAmount = amountString.replacingOccurrences(of: " ", with: "")
        let cleanedAmount: String
        if trimmedAmount.contains(",") {
            cleanedAmount = trimmedAmount
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: ".")
        } else {
            cleanedAmount = trimmedAmount
        }

        guard let amount = Decimal(string: cleanedAmount) else { return nil }

        self.title = title
        self.amount = amount
        self.identifier = identifier
    }
}
