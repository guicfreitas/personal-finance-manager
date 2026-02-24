//
//  ContentViewModel.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    enum SortOption: String, CaseIterable, Identifiable {
        case remainingInstallments
        case remainingAmount

        var id: String { rawValue }
        var title: String {
            switch self {
            case .remainingInstallments:
                return "Remaining Installments"
            case .remainingAmount:
                return "Remaining Amount"
            }
        }
    }

    enum FilterOption: String, CaseIterable, Identifiable {
        case all
        case concludedOnly
        case openOnly

        var id: String { rawValue }
        var title: String {
            switch self {
            case .all:
                return "All"
            case .concludedOnly:
                return "Concluded Only"
            case .openOnly:
                return "Open Only"
            }
        }
    }

    @Published var isPresentingAdd = false
    @Published var isPresentingImporter = false
    @Published var pendingImportURL: URL?
    @Published var isShowingImportOptions = false
    @Published var importMessage: String?
    @Published var isShowingImportResult = false
    @Published var isShowingAdvanceConfirmation = false
    @Published var isShowingShareSheet = false
    @Published var exportURL: URL?
    @Published var exportMessage: String?
    @Published var isShowingExportResult = false
    @Published var sortOption: SortOption = .remainingInstallments
    @Published var filterOption: FilterOption = .all

    func runImport(replaceExisting: Bool, modelContext: ModelContext) {
        guard let url = pendingImportURL else { return }
        let needsSecurityScope = url.startAccessingSecurityScopedResource()
        defer {
            if needsSecurityScope {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let inserted = try CSVImporter.importExpenses(
                from: url,
                replaceExisting: replaceExisting,
                modelContext: modelContext
            )
            importMessage = "Imported \(inserted) expenses."
        } catch {
            importMessage = error.localizedDescription
        }
        isShowingImportResult = true
        pendingImportURL = nil
    }

    func prepareExport(expenses: [Expense]) {
        let filename = "personal-finance-\(Date().timeIntervalSince1970).csv"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try CSVExporter.exportExpenses(expenses, to: url)
            exportURL = url
            isShowingShareSheet = true
        } catch {
            exportMessage = error.localizedDescription
            isShowingExportResult = true
        }
    }
}
