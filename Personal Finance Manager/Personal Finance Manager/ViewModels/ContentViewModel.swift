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
    @Published var isPresentingAdd = false
    @Published var isPresentingImporter = false
    @Published var pendingImportURL: URL?
    @Published var isShowingImportOptions = false
    @Published var importMessage: String?
    @Published var isShowingImportResult = false

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
}
