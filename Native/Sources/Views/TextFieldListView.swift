//
//  TextFieldListView.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import UIKit

/// A vertical list of text fields: (+) appends a row, (-) on a row removes it.
@MainActor public final class TextFieldListView: UIView {

    /// The trimmed text of every row that is not empty after trimming, in row order.
    public var values: [String] {
        return textFields
            .map { $0.trimmedText }
            .filter { !$0.isEmpty }
    }

    private let placeholder: String
    private let accessibilityIdentifierPrefix: String
    private var rows: [UIStackView] = []
    private var textFields: [PaddingAwareTextField] = []

    private let containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 8
        containerStackView.alignment = .fill
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        return containerStackView
    }()

    private let rowsStackView: UIStackView = {
        let rowsStackView = UIStackView()
        rowsStackView.axis = .vertical
        rowsStackView.spacing = 8
        rowsStackView.alignment = .fill
        return rowsStackView
    }()

    private lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.imagePadding = 6
        configuration.title = "Add \(placeholder)"
        configuration.baseForegroundColor = .accentPrimary
        let addButton = UIButton(configuration: configuration)
        addButton.contentHorizontalAlignment = .leading
        addButton.accessibilityIdentifier = "\(accessibilityIdentifierPrefix)_add_button"
        addButton.addAction(UIAction { [weak self] _ in self?.appendRow() }, for: .touchUpInside)
        return addButton
    }()

    public init(placeholder: String, accessibilityIdentifierPrefix: String) {
        self.placeholder = placeholder
        self.accessibilityIdentifierPrefix = accessibilityIdentifierPrefix
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(rowsStackView)
        containerStackView.addArrangedSubview(addButton)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        appendRow()
    }

    public required init?(coder: NSCoder) {
        self.placeholder = ""
        self.accessibilityIdentifierPrefix = ""
        super.init(coder: coder)
    }

    // MARK: - Private

    private func appendRow() {
        let textField = PaddingAwareTextField.makeInput(placeholder: placeholder, accessibilityIdentifier: "")

        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "minus.circle.fill")
        configuration.baseForegroundColor = .statusDanger
        let removeButton = UIButton(configuration: configuration)
        removeButton.accessibilityLabel = "Remove \(placeholder)"
        removeButton.setContentHuggingPriority(.required, for: .horizontal)
        removeButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [textField, removeButton])
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center
        removeButton.addAction(UIAction { [weak self, weak row] _ in
            guard let row else { return }
            self?.remove(row)
        }, for: .touchUpInside)

        rows.append(row)
        textFields.append(textField)
        rowsStackView.addArrangedSubview(row)
        updateAccessibilityIdentifiers()
    }

    private func remove(_ row: UIStackView) {
        guard let index = rows.firstIndex(where: { $0 === row }) else { return }

        rows.remove(at: index)
        textFields.remove(at: index)
        rowsStackView.removeArrangedSubview(row)
        row.removeFromSuperview()
        updateAccessibilityIdentifiers()
    }

    private func updateAccessibilityIdentifiers() {
        for (index, row) in rows.enumerated() {
            textFields[index].accessibilityIdentifier = "\(accessibilityIdentifierPrefix)_\(index)_input"
            row.arrangedSubviews.last?.accessibilityIdentifier = "\(accessibilityIdentifierPrefix)_\(index)_remove_button"
        }
    }
}
