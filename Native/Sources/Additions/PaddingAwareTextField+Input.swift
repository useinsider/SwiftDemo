//
//  PaddingAwareTextField+Input.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import UIKit

extension PaddingAwareTextField {

    /// Creates a styled, 44 pt high single-line input that resigns on Return.
    public static func makeInput(
        placeholder: String,
        accessibilityIdentifier: String,
        keyboardType: UIKeyboardType = .default
    ) -> PaddingAwareTextField {
        let textField = PaddingAwareTextField()
        textField.style(with: .default)
        textField.placeholder = placeholder
        textField.isAccessibilityElement = true
        textField.accessibilityLabel = placeholder
        textField.accessibilityIdentifier = accessibilityIdentifier
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.keyboardType = keyboardType
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.addAction(UIAction { _ in }, for: .editingDidEndOnExit)
        return textField
    }

    /// The text with surrounding whitespace and newlines removed; empty when nothing was entered.
    public var trimmedText: String {
        return (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
