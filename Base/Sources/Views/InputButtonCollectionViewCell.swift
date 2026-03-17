//
//  InputButtonCollectionViewCell.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import UIKit

@MainActor public final class InputButtonCollectionViewCell: UICollectionViewCell {

    private let actionIdentifier = UIAction.Identifier("action")

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.isAccessibilityElement = true
        titleLabel.style(with: .body)
        return titleLabel
    }()

    private lazy var textField: PaddingAwareTextField = {
        let textField = PaddingAwareTextField()
        textField.isAccessibilityElement = true
        textField.style(with: .default)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.clearButtonMode = .whileEditing
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(resignFirstResponder))
        doneButton.isAccessibilityElement = true
        doneButton.accessibilityTraits = .button
        doneButton.accessibilityLabel = "Close Keyboard"
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar

        return textField
    }()

    private let actionButton: DynamicFontAwareButton = {
        let actionButton = DynamicFontAwareButton(configuration: .filled())
        actionButton.setTitle("SET", for: .normal)
        actionButton.style(with: .secondary, size: .small)
        actionButton.isAccessibilityElement = true
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        return actionButton
    }()

    private lazy var inputStackView: UIStackView = {
        let inputStackView = UIStackView(arrangedSubviews: [textField, actionButton])
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.axis = .horizontal
        inputStackView.spacing = 5.0
        return inputStackView
    }()

    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, inputStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 5.0
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(inset: 5.0)
        return mainStackView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = false
        shouldGroupAccessibilityChildren = true
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            inputStackView.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }

    private func getInput() -> String {
        return textField.text ?? String()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setAction(action: AnyAction) {
        titleLabel.text = action.title
        actionButton.removeAction(identifiedBy: actionIdentifier, for: .touchUpInside)
        actionButton.addAction(UIAction(identifier: actionIdentifier) { [unowned self] _ in
            var thisAction = action
            thisAction.setInput(getInput()).execute()
        }, for: .touchUpInside)

        let accessibilityIdentifier = action.accessibilityIdentifier
        self.accessibilityIdentifier = "\(accessibilityIdentifier)_cell"
        self.accessibilityLabel = "\(action.title) Cell"

        actionButton.accessibilityIdentifier = "\(accessibilityIdentifier)_button"
        actionButton.accessibilityLabel = "Set \(action.title)"

        titleLabel.accessibilityIdentifier = "\(accessibilityIdentifier)_title"
        titleLabel.accessibilityLabel = "\(action.title)"

        textField.accessibilityIdentifier = "\(accessibilityIdentifier)_input"
        textField.accessibilityLabel = "\(action.title) Input"
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        actionButton.removeAction(identifiedBy: actionIdentifier, for: .touchUpInside)
        textField.text = .none
    }
}
