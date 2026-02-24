//
//  CSVImport.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation
import SwiftData

enum CSVImportError: Error, LocalizedError {
    case emptyFile
    case unreadableFile

    var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "CSV file is empty."
        case .unreadableFile:
            return "CSV file could not be read."
        }
    }
}

struct CSVImporter {
    static func importExpenses(
        from url: URL,
        replaceExisting: Bool,
        modelContext: ModelContext
    ) throws -> Int {
        let raw = try loadText(from: url)

        let lines = raw
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        guard !lines.isEmpty else {
            throw CSVImportError.emptyFile
        }

        if replaceExisting {
            let existing = try modelContext.fetch(FetchDescriptor<Expense>())
            for expense in existing {
                modelContext.delete(expense)
            }
        }

        var inserted = 0
        for line in lines {
            let columns = line.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            if columns.count < 2 { continue }

            let title = columns[0]
            if title.isEmpty { continue }
            if title.lowercased().hasPrefix("total") { continue }

            let totalAmount = decimal(from: columns[safe: 1]) ?? .zero
            let paidInstallments = int(from: columns[safe: 3]) ?? 0
            let totalInstallments = int(from: columns[safe: 4]) ?? 1
            let installmentValue = decimal(from: columns[safe: 5]) ?? decimal(from: columns[safe: 2]) ?? .zero
            let lastUpdated = date(from: columns[safe: 6]) ?? Date()

            let expense = Expense(
                title: title,
                totalAmount: totalAmount,
                installmentValue: installmentValue,
                paidInstallments: paidInstallments,
                totalInstallments: totalInstallments,
                lastUpdated: lastUpdated
            )
            modelContext.insert(expense)
            inserted += 1
        }

        return inserted
    }

    private static func loadText(from url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        if let text = String(data: data, encoding: .utf8) {
            return text
        }
        if let text = String(data: data, encoding: .isoLatin1) {
            return text
        }
        if let text = String(data: data, encoding: .windowsCP1252) {
            return text
        }
        throw CSVImportError.unreadableFile
    }

    private static func decimal(from raw: String?) -> Decimal? {
        guard let raw, !raw.isEmpty else { return nil }
        let cleaned = raw
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Decimal(string: cleaned)
    }

    private static func int(from raw: String?) -> Int? {
        guard let raw, !raw.isEmpty else { return nil }
        return Int(raw)
    }

    private static func date(from raw: String?) -> Date? {
        guard let raw, !raw.isEmpty else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.date(from: raw)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
