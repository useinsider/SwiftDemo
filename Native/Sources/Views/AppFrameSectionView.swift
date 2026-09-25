//
//  AppFrameSectionView.swift
//  Example
//
//  Created by Özgür Vatansever on 21.07.2026.
//

import InsiderMobile
import UIKit

@MainActor public final class AppFrameSectionView: UIView {

    public enum Event {
        case statusChange(InsiderAppFramesViewStatus, from: InsiderAppFramesViewStatus)
        case failed(String)
        case heightChange(CGFloat)
        case action
    }

    private struct Counters {
        var load = 0
        var height = 0
        var action = 0
        var error = 0

        var summary: String {
            return "load \(load) · height \(height) · action \(action) · error \(error)"
        }
    }

    public var onDelete: ((AppFrameSectionView) -> Void)?

    public let framesView: InsiderAppFramesView = {
        let framesView = InsiderAppFramesView()
        framesView.translatesAutoresizingMaskIntoConstraints = false
        framesView.layer.cornerRadius = 12
        framesView.clipsToBounds = true
        return framesView
    }()

    private var counters = Counters()

    private let containerView: UIStackView = {
        let containerView = UIStackView()
        containerView.axis = .vertical
        containerView.spacing = 8
        containerView.alignment = .fill
        containerView.distribution = .fill
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private let headerView: UIStackView = {
        let headerView = UIStackView()
        headerView.axis = .horizontal
        headerView.spacing = 8
        headerView.alignment = .center
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    private let placementIdLabel: UILabel = {
        let placementIdLabel = UILabel()
        placementIdLabel.style(with: .heading6)
        placementIdLabel.numberOfLines = 1
        placementIdLabel.lineBreakMode = .byTruncatingMiddle
        placementIdLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return placementIdLabel
    }()

    private let attachmentButton: DynamicFontAwareButton = {
        let attachmentButton = DynamicFontAwareButton(type: .system)
        attachmentButton.style(with: .secondary, size: .small)
        attachmentButton.isAccessibilityElement = true
        attachmentButton.accessibilityLabel = "Toggle Frame Attachment"
        attachmentButton.setContentHuggingPriority(.required, for: .horizontal)
        return attachmentButton
    }()

    private let deleteButton: DynamicFontAwareButton = {
        let deleteButton = DynamicFontAwareButton(type: .system)
        deleteButton.style(with: .destructive, size: .small)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.isAccessibilityElement = true
        deleteButton.accessibilityLabel = "Delete Frame Section"
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
        return deleteButton
    }()

    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.style(with: .caption)
        statusLabel.numberOfLines = 0
        return statusLabel
    }()

    private let counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.style(with: .caption)
        counterLabel.numberOfLines = 1
        return counterLabel
    }()

    public init(placementId: String) {
        super.init(frame: .zero)
        isAccessibilityElement = false
        shouldGroupAccessibilityChildren = true
        placementIdLabel.text = placementId
        counterLabel.text = counters.summary
        framesView.placementId = placementId
        statusLabel.text = framesView.status.stringValue
        setupViewsAndConstraints()
        setupActions()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setAccessibilityOrder(index: Int) {
        let accessibilityIdentifier = "app_frame_section_\(index)"
        self.accessibilityIdentifier = accessibilityIdentifier
        attachmentButton.accessibilityIdentifier = "\(accessibilityIdentifier)_attachment_button"
        deleteButton.accessibilityIdentifier = "\(accessibilityIdentifier)_delete_button"
        placementIdLabel.accessibilityIdentifier = "\(accessibilityIdentifier)_placement_id"
        statusLabel.accessibilityIdentifier = "\(accessibilityIdentifier)_status"
        counterLabel.accessibilityIdentifier = "\(accessibilityIdentifier)_counters"
    }

    /// Updates the status line and the per-callback counters for `event`.
    public func record(_ event: Event) {
        switch event {
        case .statusChange(let status, from: let previousStatus):
            if status == .ready {
                counters.load += 1
            }
            statusLabel.text = "\(previousStatus.stringValue) → \(status.stringValue)"
        case .failed(let description):
            counters.error += 1
            statusLabel.text = "failed — \(description)"
        case .heightChange(let optimalHeight):
            counters.height += 1
            statusLabel.text = "heightChange \(optimalHeight)"
        case .action:
            counters.action += 1
            statusLabel.text = "action"
        }
        counterLabel.text = counters.summary
    }

    private func setupViewsAndConstraints() {
        addSubview(containerView)

        headerView.addArrangedSubview(placementIdLabel)
        headerView.addArrangedSubview(attachmentButton)
        headerView.addArrangedSubview(deleteButton)

        containerView.addArrangedSubview(headerView)
        containerView.addArrangedSubview(framesView)
        containerView.addArrangedSubview(statusLabel)
        containerView.addArrangedSubview(counterLabel)

        updateAttachmentButtonTitle()

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupActions() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        attachmentButton.addTarget(self, action: #selector(attachmentButtonTapped), for: .touchUpInside)
    }

    @objc private func deleteButtonTapped() {
        onDelete?(self)
    }

    @objc private func attachmentButtonTapped() {
        if framesView.superview == nil {
            containerView.insertArrangedSubview(framesView, at: 1)
        } else {
            containerView.removeArrangedSubview(framesView)
            framesView.removeFromSuperview()
        }
        updateAttachmentButtonTitle()
    }

    private func updateAttachmentButtonTitle() {
        let title = framesView.superview == nil ? "Attach" : "Detach"
        attachmentButton.setTitle(title, for: .normal)
    }
}
