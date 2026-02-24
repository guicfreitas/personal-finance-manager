//
//  View+Keyboard.swift
//  Personal Finance Manager
//
//  Created by João Guilherme on 24/02/26.
//

import SwiftUI
import UIKit

extension View {
    func dismissKeyboardOnTap() -> some View {
        background(KeyboardDismissTapView())
    }
}

private struct KeyboardDismissTapView: View {
    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture { UIApplication.shared.endEditing() }
    }
}

private extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
