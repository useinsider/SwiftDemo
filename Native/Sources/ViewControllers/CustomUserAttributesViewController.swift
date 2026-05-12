//
//  CustomUserAttributesViewController.swift
//  Example
//
//  Created by Insider on 3.02.2026.
//

import UIKit
import InsiderMobile

public final class CustomUserAttributesViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .backgroundPrimary
        return scrollView
    }()

    private let contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 10
        contentView.alignment = .fill
        contentView.distribution = .fill
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(inset: 10)
        return contentView
    }()

    private var attributeViews: [AttributeView] = []

    private let addAttributeButton: DynamicFontAwareButton = {
        let addAttributeButton = DynamicFontAwareButton(type: .system)
        addAttributeButton.style(with: .destructive)
        addAttributeButton.isAccessibilityElement = true
        addAttributeButton.accessibilityLabel = "Add Attribute"
        addAttributeButton.accessibilityIdentifier = "add_attribute_button"
        addAttributeButton.setTitle("+ Add Attribute", for: .normal)
        addAttributeButton.translatesAutoresizingMaskIntoConstraints = false
        return addAttributeButton
    }()

    private let setAttributesButton: DynamicFontAwareButton = {
        let setAttributesButton = DynamicFontAwareButton(type: .system)
        setAttributesButton.style(with: .primary)
        setAttributesButton.isAccessibilityElement = true
        setAttributesButton.accessibilityLabel = "Set Attributes"
        setAttributesButton.accessibilityIdentifier = "set_attributes_button"
        setAttributesButton.setTitle("Set Attributes", for: .normal)
        setAttributesButton.translatesAutoresizingMaskIntoConstraints = false
        return setAttributesButton
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Set User Attributes"
        view.backgroundColor = .backgroundPrimary
        setupViewsAndConstrainsts()
        setupKeyboardDismissal()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Insider.disableInAppMessages()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        Insider.enableInAppMessages()
        super.viewDidDisappear(animated)
    }

    private func setupViewsAndConstrainsts() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Add Attribute Button
        addAttributeButton.addTarget(self, action: #selector(addAttributeRow), for: .touchUpInside)
        contentView.addArrangedSubview(addAttributeButton)

        // Spacer
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentView.addArrangedSubview(spacerView)

        // Set Attributes Button
        setAttributesButton.addTarget(self, action: #selector(setAttributesButtonPressed), for: .touchUpInside)
        contentView.addArrangedSubview(setAttributesButton)

        // Add initial attribute row
        addAttributeRow()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            setAttributesButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func createSectionLabel(text: String) -> UILabel {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = text
        textLabel.style(with: .body)
        return textLabel
    }

    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func addAttributeRow() {
        let attributeView = AttributeView()
        attributeView.onDelete = { [unowned self] view in
            self.removeAttributeRow(view)
        }
        attributeViews.append(attributeView)
        attributeView.setAccessibilityOrder(index: attributeViews.endIndex - 1)

        // Insert before the add button
        if let insertIndex = contentView.arrangedSubviews.firstIndex(of: addAttributeButton) {
            contentView.insertArrangedSubview(attributeView, at: insertIndex)
        }
    }

    private func removeAttributeRow(_ view: AttributeView) {
        guard !attributeViews.isEmpty else { return }

        if let index = attributeViews.firstIndex(of: view) {
            attributeViews.remove(at: index)
            contentView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    private func attachToolbar(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(resignFirstResponder))
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }

    @objc private func setAttributesButtonPressed() {
        // Set attributes
        for view in attributeViews {
            guard let (key, value, type) = view.getAttribute() else {
                continue
            }
            switch type {
            case .string:
                Insider.getCurrentUser().setCustomAttributeWithString()(key, value)
            case .integer:
                if let intValue = Int(value) {
                    Insider.getCurrentUser().setCustomAttributeWithInt()(key, intValue)
                }
            case .double:
                if let doubleValue = Double(value) {
                    Insider.getCurrentUser().setCustomAttributeWithDouble()(key, doubleValue)
                }
            case .boolean:
                if ["yes", "true", "1"].contains(value.lowercased()) {
                    Insider.getCurrentUser().setCustomAttributeWithBoolean()(key, true)
                } else {
                    Insider.getCurrentUser().setCustomAttributeWithBoolean()(key, false)
                }
            }
        }
    }
}

// MARK: - AttributeView

private final class AttributeView: UIView {

    public enum AttributeType: String, CaseIterable {
        case string = "String"
        case integer = "Integer"
        case double = "Double"
        case boolean = "Boolean"
    }

    public var onDelete: ((AttributeView) -> Void)?

    private let containerView: UIStackView = {
        let containerView = UIStackView()
        containerView.axis = .vertical
        containerView.spacing = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private let textFieldsView: UIStackView = {
        let textFieldsView = UIStackView()
        textFieldsView.axis = .horizontal
        textFieldsView.distribution = .fillEqually
        textFieldsView.spacing = 10
        textFieldsView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldsView
    }()

    private let keyTextField: PaddingAwareTextField = {
        let keyTextField = PaddingAwareTextField()
        keyTextField.style(with: .default)
        keyTextField.isAccessibilityElement = true
        keyTextField.accessibilityLabel = "Attribute Name Input"
        keyTextField.placeholder = "Name"
        keyTextField.autocapitalizationType = .none
        keyTextField.autocorrectionType = .no
        keyTextField.clearButtonMode = .whileEditing
        return keyTextField
    }()

    private let typeSegmentedControl: UISegmentedControl = {
        let items = AttributeType.allCases.map { $0.rawValue }
        let typeSegmentedControl = UISegmentedControl(items: items)
        typeSegmentedControl.isAccessibilityElement = true
        typeSegmentedControl.accessibilityLabel = "Attribute Type Select"

        typeSegmentedControl.selectedSegmentIndex = 0
        return typeSegmentedControl
    }()

    private let valueTextField: PaddingAwareTextField = {
        let valueTextField = PaddingAwareTextField()
        valueTextField.style(with: .default)
        valueTextField.isAccessibilityElement = true
        valueTextField.accessibilityLabel = "Attribute Value Input"
        valueTextField.placeholder = "Value"
        valueTextField.autocorrectionType = .no
        valueTextField.clearButtonMode = .whileEditing
        return valueTextField
    }()

    private let deleteButton: DynamicFontAwareButton = {
        let deleteButton = DynamicFontAwareButton(type: .system)
        deleteButton.style(with: .destructive, size: .small)
        deleteButton.isAccessibilityElement = true
        deleteButton.accessibilityTraits = .button
        deleteButton.accessibilityLabel = "Delete Attribute"
        deleteButton.setTitle("Delete", for: .normal)
        return deleteButton
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = false
        shouldGroupAccessibilityChildren = true
        setupViewsAndConstrainsts()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViewsAndConstrainsts() {
        addSubview(containerView)

        attachToolbar(to: keyTextField)
        textFieldsView.addArrangedSubview(keyTextField)
        attachToolbar(to: valueTextField)
        textFieldsView.addArrangedSubview(valueTextField)

        containerView.addArrangedSubview(typeSegmentedControl)
        containerView.addArrangedSubview(textFieldsView)
        containerView.addArrangedSubview(deleteButton)

        let dividerView = UIView()
        dividerView.backgroundColor = .separator
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(dividerView)

        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            keyTextField.heightAnchor.constraint(equalToConstant: 44),
            valueTextField.heightAnchor.constraint(equalToConstant: 44),
            typeSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func attachToolbar(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(resignFirstResponder))
        doneButton.isAccessibilityElement = true
        doneButton.accessibilityTraits = .button
        doneButton.accessibilityLabel = "Close Keyboard"
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }

    @objc private func deleteButtonPressed() {
        onDelete?(self)
    }

    public func getAttribute() -> (String, String, AttributeType)? {
        guard let key = keyTextField.text, !key.isEmpty,
              let value = valueTextField.text, !value.isEmpty else {
            return nil
        }
        let type = AttributeType.allCases[typeSegmentedControl.selectedSegmentIndex]
        return (key, value, type)
    }

    public func clear() {
        keyTextField.text = ""
        valueTextField.text = ""
        typeSegmentedControl.selectedSegmentIndex = 0
    }

    public func setAccessibilityOrder(index: Int) {
        let accessibilityIdentifier = "attribute_row_\(index)"
        self.accessibilityIdentifier = accessibilityIdentifier
        typeSegmentedControl.accessibilityIdentifier = "\(accessibilityIdentifier)_type_select"
        keyTextField.accessibilityIdentifier = "\(accessibilityIdentifier)_name_input"
        valueTextField.accessibilityIdentifier = "\(accessibilityIdentifier)_value_input"
        deleteButton.accessibilityIdentifier = "\(accessibilityIdentifier)_delete_button"
    }
}
