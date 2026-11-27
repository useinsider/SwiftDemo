//
//  SmartRecommenderProductCell.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import InsiderMobile
import UIKit

/// A recommended product card: image on the left; name, prices and item id on the right; a click button below.
@MainActor public final class SmartRecommenderProductCell: UICollectionViewCell {

    public static let reuseIdentifier = "SmartRecommenderProductCell"

    /// Called when the click button is tapped.
    public var onClick: (() -> Void)?

    private static let priceFormatter: NumberFormatter = {
        let priceFormatter = NumberFormatter()
        priceFormatter.locale = Locale(identifier: "en_US_POSIX")
        priceFormatter.numberStyle = .decimal
        priceFormatter.minimumFractionDigits = 2
        priceFormatter.maximumFractionDigits = 2
        return priceFormatter
    }()

    private let productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1.0)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        return productImageView
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .font(Font(size: 15, emphasis: .bold))
        nameLabel.textColor = .textPrimary
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byTruncatingTail
        return nameLabel
    }()

    private let originalPriceLabel: UILabel = {
        let originalPriceLabel = UILabel()
        originalPriceLabel.setContentHuggingPriority(.required, for: .horizontal)
        return originalPriceLabel
    }()

    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .font(Font(size: 14, emphasis: .bold))
        priceLabel.textColor = .textPrimary
        return priceLabel
    }()

    private let itemIdLabel: UILabel = {
        let itemIdLabel = UILabel()
        itemIdLabel.numberOfLines = 1
        return itemIdLabel
    }()

    private lazy var clickButton: DynamicFontAwareButton = {
        let clickButton = DynamicFontAwareButton(configuration: .filled())
        clickButton.style(with: .secondary, size: .small)
        clickButton.setTitle("Click", for: .normal)
        clickButton.isAccessibilityElement = true
        clickButton.accessibilityTraits = .button
        clickButton.accessibilityLabel = "Click"
        clickButton.translatesAutoresizingMaskIntoConstraints = false
        clickButton.addAction(UIAction { [weak self] _ in self?.onClick?() }, for: .touchUpInside)
        return clickButton
    }()

    private lazy var priceStackView: UIStackView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let priceStackView = UIStackView(arrangedSubviews: [originalPriceLabel, priceLabel, spacer])
        priceStackView.axis = .horizontal
        priceStackView.spacing = 6
        priceStackView.alignment = .firstBaseline
        return priceStackView
    }()

    private lazy var textStackView: UIStackView = {
        let textStackView = UIStackView(arrangedSubviews: [nameLabel, priceStackView, itemIdLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.alignment = .fill
        textStackView.setCustomSpacing(6, after: priceStackView)
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        return textStackView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.style { $0.variant(.card) }
        setupViewsAndConstraints()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.cancelDownloadingImage()
        productImageView.image = nil
        onClick = nil
    }

    /// Shows a product of a products response.
    public func configure(with product: InsiderAppSmartRecommenderProductModel, index: Int) {
        accessibilityIdentifier = "product_cell_\(index)"
        clickButton.accessibilityIdentifier = "product_click_button_\(index)"
        nameLabel.text = product.name

        let price = NSNumber(value: product.price)
        priceLabel.text = "\(Self.format(price)) \(product.currency)"

        if let originalPrice = product.originalPrice, originalPrice.doubleValue != product.price {
            originalPriceLabel.attributedText = NSAttributedString(
                string: Self.format(originalPrice),
                attributes: [
                    .font: UIFont.font(Font(size: 13, emphasis: .regular)),
                    .foregroundColor: UIColor.textTertiary,
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            originalPriceLabel.isHidden = false
        } else {
            originalPriceLabel.attributedText = nil
            originalPriceLabel.isHidden = true
        }

        itemIdLabel.attributedText = NSAttributedString(
            string: product.productId.uppercased(),
            attributes: [
                .font: UIFont.font(Font(size: 11, emphasis: .regular)),
                .foregroundColor: UIColor.textTertiary,
                .kern: 0.66
            ]
        )

        if let imageURLString = product.imageUrl, let imageURL = URL(string: imageURLString) {
            productImageView.setImage(from: imageURL)
        } else {
            productImageView.cancelDownloadingImage()
            productImageView.image = nil
        }
    }

    // MARK: - Private

    private static func format(_ price: NSNumber) -> String {
        return priceFormatter.string(from: price) ?? price.stringValue
    }

    private func setupViewsAndConstraints() {
        contentView.addSubview(productImageView)
        contentView.addSubview(textStackView)
        contentView.addSubview(clickButton)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.widthAnchor.constraint(equalToConstant: 72),
            productImageView.heightAnchor.constraint(equalToConstant: 72),

            textStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textStackView.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            textStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: clickButton.topAnchor, constant: -8),

            clickButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            clickButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            clickButton.topAnchor.constraint(greaterThanOrEqualTo: productImageView.bottomAnchor, constant: 8),
            clickButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
