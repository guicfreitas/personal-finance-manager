//
//  CSVExport.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation

enum CSVExportError: Error, LocalizedError {
    case failedToWrite

    var errorDescription: String? {
        switch self {
        case .failedToWrite:
            return "CSV file could not be written."
        }
    }
}

struct CSVExporter {
    static func exportExpenses(_ expenses: [Expense], to url: URL) throws {
        let csv = makeCSV(expenses)
        guard let data = csv.data(using: .utf8) else {
            throw CSVExportError.failedToWrite
        }
        do {
            try data.write(to: url, options: [.atomic])
        } catch {
            throw CSVExportError.failedToWrite
        }
    }

    static func makeCSV(_ expenses: [Expense]) -> String {
        let header = [
            "Item",
            "Total",
            "Parcelas individuais",
            "Parcelas pagas",
            "Parcelas totais",
            "Parcelas individuais",
            "Ultima Atualizacao"
        ].joined(separator: ";")

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")

        var lines: [String] = [header]

        for expense in expenses {
            let total = formatDecimal(expense.totalAmount)
            let installment = formatDecimal(expense.installmentValue)
            let paid = String(expense.paidInstallments)
            let totalInstallments = String(expense.totalInstallments)
            let lastUpdated = formatter.string(from: expense.lastUpdated)

            let line = [
                sanitize(expense.title),
                total,
                installment,
                paid,
                totalInstallments,
                installment,
                lastUpdated
            ].joined(separator: ";")

            lines.append(line)
        }

        let totalInstallmentsSum = expenses.reduce(Decimal.zero) { partial, expense in
            guard expense.remainingInstallments > 0 else { return partial }
            return partial + expense.installmentValue
        }
        let totalLine = [
            "Total Mes Atual:",
            "",
            formatDecimal(totalInstallmentsSum),
            "",
            "",
            "",
            formatter.string(from: Date())
        ].joined(separator: ";")
        lines.append(totalLine)

        return lines.joined(separator: "\n")
    }

    private static func formatDecimal(_ value: Decimal) -> String {
        let number = NSDecimalNumber(decimal: value)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number) ?? "0,00"
    }

    private static func sanitize(_ value: String) -> String {
        value.replacingOccurrences(of: ";", with: ",")
    }
}
