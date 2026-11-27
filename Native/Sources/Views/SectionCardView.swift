//
//  SectionCardView.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import UIKit

/// A titled card whose content can optionally be collapsed by tapping its header.
@MainActor public final class SectionCardView: UIView {

    public let contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        return contentStackView
    }()

    public private(set) var isExpanded: Bool

    private let isCollapsible: Bool

    private let containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 12
        containerStackView.alignment = .fill
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(inset: 16)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        return containerStackView
    }()

    private let headerStackView: UIStackView = {
        let headerStackView = UIStackView()
        headerStackView.axis = .horizontal
        headerStackView.spacing = 8
        headerStackView.alignment = .center
        return headerStackView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.style(with: .heading4)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return titleLabel
    }()

    private let chevronImageView: UIImageView = {
        let chevronImageView = UIImageView()
        chevronImageView.tintColor = .textSecondary
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        chevronImageView.setContentHuggingPriority(.required, for: .horizontal)
        return chevronImageView
    }()

    public init(title: String?, isCollapsible: Bool = false, accessibilityIdentifier: String) {
        self.isCollapsible = isCollapsible
        self.isExpanded = !isCollapsible
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        style { $0.variant(.card) }
        self.accessibilityIdentifier = accessibilityIdentifier
        titleLabel.text = title
        setupViewsAndConstraints(title: title, accessibilityIdentifier: accessibilityIdentifier)
        updateExpansionState()
    }

    public required init?(coder: NSCoder) {
        self.isCollapsible = false
        self.isExpanded = true
        super.init(coder: coder)
    }

    // MARK: - Private

    private func setupViewsAndConstraints(title: String?, accessibilityIdentifier: String) {
        addSubview(containerStackView)

        if title != nil {
            headerStackView.addArrangedSubview(titleLabel)
            if isCollapsible {
                headerStackView.addArrangedSubview(chevronImageView)
                headerStackView.isAccessibilityElement = true
                headerStackView.accessibilityTraits = .button
                headerStackView.accessibilityLabel = title
                headerStackView.accessibilityIdentifier = "\(accessibilityIdentifier)_header"
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
                headerStackView.addGestureRecognizer(tapGesture)
            }
            containerStackView.addArrangedSubview(headerStackView)
        }
        containerStackView.addArrangedSubview(contentStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func headerTapped() {
        isExpanded.toggle()
        updateExpansionState()
    }

    private func updateExpansionState() {
        contentStackView.isHidden = !isExpanded
        chevronImageView.image = UIImage(systemName: isExpanded ? "chevron.down" : "chevron.right")
        headerStackView.accessibilityValue = isExpanded ? "Expanded" : "Collapsed"
    }
}
