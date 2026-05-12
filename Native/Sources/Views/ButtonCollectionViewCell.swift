//
//  ButtonCollectionViewCell.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import UIKit

@MainActor public final class ButtonCollectionViewCell: UICollectionViewCell {

    private let actionIdentifier = UIAction.Identifier("action")

    private lazy var actionButton: DynamicFontAwareButton = {
        let actionButton = DynamicFontAwareButton(configuration: .filled())
        actionButton.style(with: .primary)
        actionButton.configuration?.titleLineBreakMode = .byWordWrapping
        actionButton.configuration?.titleAlignment = .center
        actionButton.isAccessibilityElement = true
        actionButton.accessibilityTraits = .button
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        return actionButton
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = false
        shouldGroupAccessibilityChildren = true
        contentView.addSubview(actionButton)
        contentView.addConstraints([
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        actionButton.removeAction(identifiedBy: actionIdentifier, for: .touchUpInside)
    }

    public func setAction(action: AnyAction) {
        actionButton.setTitle(action.title, for: .normal)
        actionButton.accessibilityValue = action.title
        actionButton.removeAction(identifiedBy: actionIdentifier, for: .touchUpInside)
        actionButton.addAction(UIAction(identifier: actionIdentifier) { _ in action.execute() }, for: .touchUpInside)

        let accessibilityIdentifier = action.accessibilityIdentifier
        self.accessibilityIdentifier = "\(accessibilityIdentifier)_cell"
        self.accessibilityLabel = "\(action.title) Cell"

        actionButton.accessibilityIdentifier = "\(accessibilityIdentifier)_button"
        actionButton.accessibilityLabel = action.title
    }
}
