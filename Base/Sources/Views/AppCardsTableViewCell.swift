//
//  AppCardsTableViewCell.swift
//  Example
//
//  Created by Insider on 26.03.2026.
//

import UIKit
import InsiderMobile

@MainActor public final class AppCardsTableViewCell: UITableViewCell {

    private let readStatusActionIdentifier = UIAction.Identifier("readstatus")
    private let detailsActionIdentifier = UIAction.Identifier("details")

    public var setReadStatusAction: ((Bool) -> Void)?
    public var detailsButtonAction: (() -> Void)?

    private let containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = 10
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(inset: 10)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        return containerStackView
    }()

    private let headerContainerStackView: UIStackView = {
        let headerContainerStackView = UIStackView()
        headerContainerStackView.axis = .horizontal
        headerContainerStackView.alignment = .center
        headerContainerStackView.distribution = .fill
        headerContainerStackView.spacing = 8
        headerContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        return headerContainerStackView
    }()

    private let readStatusIndicatorButton: DynamicFontAwareButton = {
        let readStatusIndicatorButton = DynamicFontAwareButton(configuration: .filled())
        readStatusIndicatorButton.isAccessibilityElement = true
        readStatusIndicatorButton.accessibilityTraits = .button
        readStatusIndicatorButton.accessibilityLabel = "ToggleReadStatus"
        readStatusIndicatorButton.style(with: .tertiary, size: .small)
        readStatusIndicatorButton.configuration?.imagePlacement = .leading
        readStatusIndicatorButton.configuration?.imagePadding = 2.5
        readStatusIndicatorButton.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
            pointSize: 5.0,
            weight: .regular
        )
        readStatusIndicatorButton.configuration?.contentInsets = NSDirectionalEdgeInsets(inset: 5.0)
        readStatusIndicatorButton.configuration?.cornerStyle = .medium

        readStatusIndicatorButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        readStatusIndicatorButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        readStatusIndicatorButton.translatesAutoresizingMaskIntoConstraints = false
        return readStatusIndicatorButton
    }()

    private let idLabel: UILabel = {
        let idLabel = UILabel()
        idLabel.style(with: .bodySmall)
        idLabel.isAccessibilityElement = true
        idLabel.accessibilityLabel = "Id"
        idLabel.numberOfLines = 1
        idLabel.lineBreakMode = .byTruncatingMiddle
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return idLabel
    }()

    private let detailsButton: DynamicFontAwareButton = {
        let detailsButton = DynamicFontAwareButton(configuration: .plain())
        detailsButton.isAccessibilityElement = true
        detailsButton.accessibilityTraits = .button
        detailsButton.accessibilityLabel = "Details"
        detailsButton.style(with: .tertiary, size: .small)
        detailsButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        detailsButton.configuration?.cornerStyle = .small
        detailsButton.setTitle("Details", for: .normal)

        detailsButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailsButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        return detailsButton
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.style(with: .body)
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "Title"
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.style(with: .bodySmall)
        subtitleLabel.isAccessibilityElement = true
        subtitleLabel.accessibilityLabel = "Subtitle"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()

    private let imagesScrollView: UIScrollView = {
        let imagesScrollView = UIScrollView()
        imagesScrollView.showsHorizontalScrollIndicator = false
        imagesScrollView.showsVerticalScrollIndicator = false
        imagesScrollView.translatesAutoresizingMaskIntoConstraints = false
        return imagesScrollView
    }()

    private let imagesStackView: UIStackView = {
        let imagesStackView = UIStackView()
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false
        imagesStackView.axis = .horizontal
        imagesStackView.alignment = .fill
        imagesStackView.distribution = .fill
        imagesStackView.spacing = 10
        return imagesStackView
    }()

    private let actionsStackView: UIStackView = {
        let actionsStackView = UIStackView()
        actionsStackView.axis = .horizontal
        actionsStackView.alignment = .fill
        actionsStackView.distribution = .fillEqually
        actionsStackView.spacing = 10
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        return actionsStackView
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isAccessibilityElement = false
        shouldGroupAccessibilityChildren = true
        contentView.addSubview(containerStackView)

        headerContainerStackView.addArrangedSubview(readStatusIndicatorButton)
        headerContainerStackView.addArrangedSubview(idLabel)
        headerContainerStackView.addArrangedSubview(detailsButton)

        // Setup images scroll view
        imagesScrollView.addSubview(imagesStackView)

        containerStackView.addArrangedSubview(headerContainerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(subtitleLabel)
        containerStackView.addArrangedSubview(imagesScrollView)
        containerStackView.addArrangedSubview(actionsStackView)

        let scrollViewHeight = imagesScrollView.heightAnchor.constraint(equalToConstant: 120)
        scrollViewHeight.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imagesStackView.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            imagesStackView.leadingAnchor.constraint(equalTo: imagesScrollView.leadingAnchor),
            imagesStackView.trailingAnchor.constraint(equalTo: imagesScrollView.trailingAnchor),
            imagesStackView.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            imagesStackView.heightAnchor.constraint(equalTo: imagesScrollView.heightAnchor),

            scrollViewHeight
        ])
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func configure(
        with message: InsiderAppCardModel,
        onButtonPressed: @escaping ((InsiderAppCardButtonModel) -> Void)
    ) {
        let accessibilityIdentifier = message.appCardId
        self.accessibilityIdentifier = "\(accessibilityIdentifier)_cell"
        self.accessibilityLabel = "Message Cell"

        idLabel.accessibilityIdentifier = "\(accessibilityIdentifier)_id"
        titleLabel.accessibilityIdentifier = "\(accessibilityIdentifier)_title"
        subtitleLabel.accessibilityIdentifier = "\(accessibilityIdentifier)_subtitle"
        readStatusIndicatorButton.accessibilityIdentifier = "\(accessibilityIdentifier)_readstatus"
        detailsButton.accessibilityIdentifier = "\(accessibilityIdentifier)_details"

        idLabel.text = message.appCardId
        idLabel.accessibilityValue = message.appCardId

        // Set title and subtitle from content item
        if let content = message.content {
            titleLabel.text = content.title
            titleLabel.isHidden = false
            titleLabel.accessibilityValue = content.title
            subtitleLabel.text = content.subtitle
            subtitleLabel.isHidden = false
            subtitleLabel.accessibilityValue = content.subtitle
        } else {
            titleLabel.text = nil
            titleLabel.isHidden = true
            titleLabel.accessibilityValue = nil
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true
            subtitleLabel.accessibilityValue = nil
        }
        // Configure read status indicator button based on message read status
        updateReadStatusIndicatorButton(isRead: message.isRead)

        // Remove previous actions to avoid duplicates
        readStatusIndicatorButton.removeAction(
            identifiedBy: readStatusActionIdentifier,
            for: .touchUpInside
        )

        // Add action to toggle read/unread status
        let action = UIAction(identifier: readStatusActionIdentifier) { [unowned self] _ in
            self.updateReadStatusIndicatorButton(isRead: !message.isRead, animated: true)
            self.setReadStatusAction?(!message.isRead)
        }
        readStatusIndicatorButton.addAction(action, for: .touchUpInside)

        // Remove previous details button action to avoid duplicates
        detailsButton.removeAction(
            identifiedBy: detailsActionIdentifier,
            for: .touchUpInside
        )

        // Add action for details button
        let detailsAction = UIAction(identifier: detailsActionIdentifier) { [unowned self] _ in
            self.detailsButtonAction?()
        }
        detailsButton.addAction(detailsAction, for: .touchUpInside)

        // Configure images
        configureImages(with: message.images)

        // Clear existing action buttons
        actionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add buttons for each action
        for button in message.buttons ?? [] {
            let actionButton = createActionButton(for: button)
            actionButton.addAction(UIAction { _ in onButtonPressed(button) }, for: .touchUpInside)
            actionsStackView.addArrangedSubview(actionButton)
        }
        // Hide actions stack view if there are no buttons
        actionsStackView.isHidden = (message.buttons == nil)
    }

    private func configureImages(with images: [InsiderAppCardImageModel]?) {
        guard let images = images, !images.isEmpty else {
            imagesScrollView.isHidden = true
            return
        }
        imagesScrollView.isHidden = false
        for image in images {
            let imageView = createImageView(for: image)
            imagesStackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: imagesStackView.heightAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2.0)
            ])
        }
    }

    private func createImageView(for imageModel: InsiderAppCardImageModel) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.style(with: .surface)
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = imageModel.title
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.setImage(from: imageModel.url, placeholder: UIImage(systemName: "photo"))
        return imageView
    }

    public func updateReadStatusIndicatorButton(isRead: Bool, animated: Bool = false) {
        let update = { [self] in
            if isRead {
                readStatusIndicatorButton.accessibilityValue = "Read"
                readStatusIndicatorButton.setImage(UIImage(systemName: "circle"), for: .normal)
                readStatusIndicatorButton.setTitle("Mark as unread", for: .normal)
            } else {
                readStatusIndicatorButton.accessibilityValue = "Unread"
                readStatusIndicatorButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                readStatusIndicatorButton.setTitle("Mark as read", for: .normal)
            }
        }
        if (animated) {
            UIView.animate(withDuration: 0.2, animations: update)
        } else {
            update()
        }
    }

    private func createActionButton(for model: InsiderAppCardButtonModel) -> UIButton {
        let actionButton = DynamicFontAwareButton(configuration: .filled())
        actionButton.style(with: .secondary, size: .large)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.isAccessibilityElement = true
        actionButton.accessibilityTraits = .button
        actionButton.accessibilityLabel = model.text
        actionButton.accessibilityIdentifier = "\(model.buttonId)_action"
        actionButton.setTitle(model.text, for: .normal)
        actionButton.configuration?.cornerStyle = .medium
        actionButton.configuration?.titleAlignment = .center
        actionButton.configuration?.titleLineBreakMode = .byTruncatingTail
        return actionButton
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        readStatusIndicatorButton.removeAction(
            identifiedBy: readStatusActionIdentifier,
            for: .touchUpInside
        )
        detailsButton.removeAction(
            identifiedBy: detailsActionIdentifier,
            for: .touchUpInside
        )
        titleLabel.text = nil
        subtitleLabel.text = nil
        imagesStackView.arrangedSubviews.forEach { view in
            if let view = view as? UIImageView {
                view.cancelDownloadingImage()
                view.image = nil
            }
            view.removeFromSuperview()
        }
        actionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
