//
//  AttributeConditionEditorView.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import InsiderMobile
import UIKit

/// Builds a list of App Smart Recommender attribute conditions from an attribute, an operator and a typed value.
@MainActor public final class AttributeConditionEditorView: UIView {

    private enum ValueType: CaseIterable {
        case string
        case number
        case bool

        var title: String {
            switch self {
            case .string: return "String"
            case .number: return "Number"
            case .bool: return "Bool"
            }
        }
    }

    private static let attributes: [InsiderAppSmartRecommenderAttribute] = [
        .itemId,
        .name,
        .URL,
        .imageURL,
        .description,
        .brand,
        .color,
        .size,
        .SKU,
        .gender,
        .groupCode,
        .multipack,
        .productType,
        .GTIN,
        .category,
        .inStock,
        .rating,
        .stockCount,
        .itemUpdateDate,
        .itemStartDate,
        .itemEndDate,
        .price,
        .originalPrice,
        .discount,
        .omnibusPrice,
        .omnibusDiscount
    ]

    private static let operators: [(value: InsiderAppSmartRecommenderOperator, title: String)] = [
        (.equals, "equals"),
        (.notEquals, "notEquals"),
        (.greaterThan, "greaterThan"),
        (.greaterThanOrEqual, "greaterThanOrEqual"),
        (.lessThan, "lessThan"),
        (.lessThanOrEqual, "lessThanOrEqual"),
        (.contains, "contains"),
        (.notContains, "notContains")
    ]

    private static let customAttributeTitle = "Custom…"

    /// The saved conditions, in the order they were saved.
    public private(set) var conditions: [InsiderAppSmartRecommenderAttributesFilter.Condition] = []

    private var conditionDescriptions: [String] = []

    private var isCustomAttributeSelected: Bool {
        return attributeButton.selectedIndex == Self.attributes.count
    }

    private var selectedValueType: ValueType {
        return ValueType.allCases[valueTypeButton.selectedIndex]
    }

    private let containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 12
        containerStackView.alignment = .fill
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        return containerStackView
    }()

    private let attributeButton = DropdownButton(
        options: AttributeConditionEditorView.attributes.map { $0.rawValue }
            + [AttributeConditionEditorView.customAttributeTitle],
        accessibilityIdentifier: "condition_attribute_dropdown"
    )

    private let customAttributeTextField = PaddingAwareTextField.makeInput(
        placeholder: "Custom attribute name",
        accessibilityIdentifier: "condition_custom_attribute_input"
    )

    private lazy var customAttributeInputView = LabeledInputView(
        title: "Custom attribute",
        input: customAttributeTextField
    )

    private let operatorButton = DropdownButton(
        options: AttributeConditionEditorView.operators.map { $0.title },
        accessibilityIdentifier: "condition_operator_dropdown"
    )

    private let valueTypeButton = DropdownButton(
        options: ValueType.allCases.map { $0.title },
        accessibilityIdentifier: "condition_value_type_dropdown"
    )

    private let valueTextField = PaddingAwareTextField.makeInput(
        placeholder: "Value",
        accessibilityIdentifier: "condition_value_input"
    )

    private lazy var valueTextInputView = LabeledInputView(title: "Value", input: valueTextField)

    private let valueSwitch: UISwitch = {
        let valueSwitch = UISwitch()
        valueSwitch.accessibilityIdentifier = "condition_value_switch"
        return valueSwitch
    }()

    private lazy var valueSwitchRow: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.style(with: .bodySmall)
        titleLabel.text = "Value"
        let valueSwitchRow = UIStackView(arrangedSubviews: [titleLabel, valueSwitch])
        valueSwitchRow.axis = .horizontal
        valueSwitchRow.alignment = .center
        valueSwitchRow.spacing = 8
        return valueSwitchRow
    }()

    private let saveButton: DynamicFontAwareButton = {
        let saveButton = DynamicFontAwareButton(type: .system)
        saveButton.style(with: .primary, size: .small)
        saveButton.setTitle("Save", for: .normal)
        saveButton.accessibilityIdentifier = "condition_save_button"
        return saveButton
    }()

    private let clearButton: DynamicFontAwareButton = {
        let clearButton = DynamicFontAwareButton(type: .system)
        clearButton.style(with: .destructive, size: .small)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.accessibilityIdentifier = "condition_clear_button"
        return clearButton
    }()

    private let conditionsLabel: UILabel = {
        let conditionsLabel = UILabel()
        conditionsLabel.style(with: .bodySmall)
        conditionsLabel.numberOfLines = 0
        conditionsLabel.accessibilityIdentifier = "conditions_label"
        return conditionsLabel
    }()

    public init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViewsAndConstraints()
        setupActions()
        updateInputs()
        updateConditionsLabel()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private

    private func setupViewsAndConstraints() {
        addSubview(containerStackView)

        let buttonRow = UIStackView(arrangedSubviews: [saveButton, clearButton])
        buttonRow.axis = .horizontal
        buttonRow.distribution = .fillEqually
        buttonRow.spacing = 12

        containerStackView.addArrangedSubview(LabeledInputView(title: "Attribute", input: attributeButton))
        containerStackView.addArrangedSubview(customAttributeInputView)
        containerStackView.addArrangedSubview(LabeledInputView(title: "Operator", input: operatorButton))
        containerStackView.addArrangedSubview(LabeledInputView(title: "Value type", input: valueTypeButton))
        containerStackView.addArrangedSubview(valueTextInputView)
        containerStackView.addArrangedSubview(valueSwitchRow)
        containerStackView.addArrangedSubview(buttonRow)
        containerStackView.addArrangedSubview(conditionsLabel)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupActions() {
        attributeButton.onSelect = { [weak self] _ in self?.updateInputs() }
        valueTypeButton.onSelect = { [weak self] _ in self?.updateInputs() }
        saveButton.addAction(UIAction { [weak self] _ in self?.saveCondition() }, for: .touchUpInside)
        clearButton.addAction(UIAction { [weak self] _ in self?.clearConditions() }, for: .touchUpInside)
    }

    private func updateInputs() {
        customAttributeInputView.isHidden = !isCustomAttributeSelected
        valueTextInputView.isHidden = selectedValueType == .bool
        valueSwitchRow.isHidden = selectedValueType != .bool
        valueTextField.keyboardType = selectedValueType == .number ? .numbersAndPunctuation : .default
    }

    private func saveCondition() {
        let attribute = isCustomAttributeSelected
            ? InsiderAppSmartRecommenderAttribute(rawValue: customAttributeTextField.trimmedText)
            : Self.attributes[attributeButton.selectedIndex]
        let comparisonOperator = Self.operators[operatorButton.selectedIndex]
        let condition: InsiderAppSmartRecommenderAttributesFilter.Condition
        let valueDescription: String

        switch selectedValueType {
        case .string:
            let value = valueTextField.trimmedText
            condition = .init(attribute: attribute, operator: comparisonOperator.value, string: value)
            valueDescription = "\"\(value)\""
        case .number:
            // A value that does not parse is sent as NaN so the SDK, not the page, rejects it.
            let value = Double(valueTextField.trimmedText) ?? .nan
            condition = .init(attribute: attribute, operator: comparisonOperator.value, number: NSNumber(value: value))
            valueDescription = "\(value)"
        case .bool:
            let value = valueSwitch.isOn
            condition = .init(attribute: attribute, operator: comparisonOperator.value, bool: value)
            valueDescription = "\(value)"
        }

        conditions.append(condition)
        conditionDescriptions.append(
            "\(attribute.rawValue) \(comparisonOperator.title) \(valueDescription) (\(selectedValueType.title))"
        )
        updateConditionsLabel()
    }

    private func clearConditions() {
        conditions.removeAll()
        conditionDescriptions.removeAll()
        updateConditionsLabel()
    }

    private func updateConditionsLabel() {
        guard !conditionDescriptions.isEmpty else {
            conditionsLabel.text = "No saved conditions."
            return
        }
        conditionsLabel.text = conditionDescriptions.enumerated()
            .map { index, description in
                return "\(index + 1). \(description)"
            }
            .joined(separator: "\n")
    }
}
