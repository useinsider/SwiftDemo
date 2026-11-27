//
//  ProductOptionalFieldsView.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import InsiderMobile
import UIKit

/// One optional input per public `InsiderProduct` setter that `createNewProduct` does not already cover.
@MainActor public final class ProductOptionalFieldsView: UIView {

    private enum Setter: CaseIterable {
        case saleID
        case productURL
        case color
        case voucherName
        case promotionName
        case size
        case salePrice
        case unitPrice
        case shippingCost
        case voucherDiscount
        case promotionDiscount
        case stock
        case inStock
        case quantity
        case groupCode
        case brand
        case gender
        case sku
        case multipack
        case productType
        case gtin
        case productDescription
        case tags

        var title: String {
            switch self {
            case .saleID: return "SaleID"
            case .productURL: return "ProductURL"
            case .color: return "Color"
            case .voucherName: return "VoucherName"
            case .promotionName: return "PromotionName"
            case .size: return "Size"
            case .salePrice: return "SalePrice"
            case .unitPrice: return "UnitPrice"
            case .shippingCost: return "ShippingCost"
            case .voucherDiscount: return "VoucherDiscount"
            case .promotionDiscount: return "PromotionDiscount"
            case .stock: return "Stock"
            case .inStock: return "InStock"
            case .quantity: return "Quantity"
            case .groupCode: return "GroupCode"
            case .brand: return "Brand"
            case .gender: return "Gender"
            case .sku: return "Sku"
            case .multipack: return "Multipack"
            case .productType: return "ProductType"
            case .gtin: return "Gtin"
            case .productDescription: return "Description"
            case .tags: return "Tags"
            }
        }

        var placeholder: String {
            switch self {
            case .salePrice, .unitPrice, .shippingCost, .voucherDiscount, .promotionDiscount:
                return "Number"
            case .stock, .quantity:
                return "Integer"
            case .inStock:
                return "true / false"
            case .tags:
                return "Comma separated"
            case .saleID, .productURL, .color, .voucherName, .promotionName, .size, .groupCode, .brand, .gender,
                 .sku, .multipack, .productType, .gtin, .productDescription:
                return "Text"
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .salePrice, .unitPrice, .shippingCost, .voucherDiscount, .promotionDiscount, .stock, .quantity:
                return .numbersAndPunctuation
            case .productURL:
                return .URL
            case .saleID, .color, .voucherName, .promotionName, .size, .inStock, .groupCode, .brand, .gender, .sku,
                 .multipack, .productType, .gtin, .productDescription, .tags:
                return .default
            }
        }

        func apply(_ value: String, to product: InsiderProduct) {
            switch self {
            case .saleID: product.setSaleID()(value)
            case .productURL: product.setProductURL()(value)
            case .color: product.setColor()(value)
            case .voucherName: product.setVoucherName()(value)
            case .promotionName: product.setPromotionName()(value)
            case .size: product.setSize()(value)
            case .salePrice: product.setSalePrice()(ProductOptionalFieldsView.double(value))
            case .unitPrice: product.setUnitPrice()(ProductOptionalFieldsView.double(value))
            case .shippingCost: product.setShippingCost()(ProductOptionalFieldsView.double(value))
            case .voucherDiscount: product.setVoucherDiscount()(ProductOptionalFieldsView.double(value))
            case .promotionDiscount: product.setPromotionDiscount()(ProductOptionalFieldsView.double(value))
            case .stock:
                guard let stock = Int(value) else { return }
                product.setStock()(stock)
            case .inStock:
                guard let inStock = Bool(value) else { return }
                product.setInStock()(inStock)
            case .quantity:
                guard let quantity = Int(value) else { return }
                product.setQuantity()(quantity)
            case .groupCode: product.setGroupCode()(value)
            case .brand: product.setBrand()(value)
            case .gender: product.setGender()(value)
            case .sku: product.setSku()(value)
            case .multipack: product.setMultipack()(value)
            case .productType: product.setProductType()(value)
            case .gtin: product.setGtin()(value)
            case .productDescription: product.setDescription()(value)
            case .tags: product.setTags()(ProductOptionalFieldsView.list(value))
            }
        }
    }

    private var setterInputs: [(setter: Setter, textField: PaddingAwareTextField)] = []

    private let containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 12
        containerStackView.alignment = .fill
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        return containerStackView
    }()

    public init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViewsAndConstraints()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// Calls the setter of every input that is not empty after trimming; a value its setter cannot take is skipped.
    public func apply(to product: InsiderProduct) {
        for input in setterInputs {
            let value = input.textField.trimmedText
            guard !value.isEmpty else { continue }
            input.setter.apply(value, to: product)
        }
    }

    // MARK: - Private

    // A number that does not parse is passed as NaN so the SDK, not the page, decides what to do with it.
    nonisolated private static func double(_ value: String) -> Double {
        return Double(value) ?? .nan
    }

    nonisolated private static func list(_ value: String) -> [String] {
        return value
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    private func setupViewsAndConstraints() {
        addSubview(containerStackView)

        for setter in Setter.allCases {
            let textField = PaddingAwareTextField.makeInput(
                placeholder: setter.placeholder,
                accessibilityIdentifier: "product_\(setter.title)_input",
                keyboardType: setter.keyboardType
            )
            setterInputs.append((setter, textField))
            containerStackView.addArrangedSubview(LabeledInputView(title: setter.title, input: textField))
        }

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
