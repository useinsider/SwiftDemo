//
//  CustomEventViewController.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import UIKit
import InsiderMobile

public final class CustomEventViewController: UIViewController {

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

    private let eventNameTextField: PaddingAwareTextField = {
        let eventNameTextField = PaddingAwareTextField()
        eventNameTextField.style(with: .default)
        eventNameTextField.isAccessibilityElement = true
        eventNameTextField.accessibilityLabel = "Event Name Input"
        eventNameTextField.accessibilityIdentifier = "event_name_input"
        eventNameTextField.placeholder = "e.g., product_viewed"
        eventNameTextField.autocapitalizationType = .none
        eventNameTextField.autocorrectionType = .no
        eventNameTextField.translatesAutoresizingMaskIntoConstraints = false
        eventNameTextField.returnKeyType = .done
        eventNameTextField.clearButtonMode = .whileEditing
        return eventNameTextField
    }()

    private var parameterViews: [ParameterView] = []

    private let addParameterButton: DynamicFontAwareButton = {
        let addParameterButton = DynamicFontAwareButton(type: .system)
        addParameterButton.style(with: .destructive)
        addParameterButton.isAccessibilityElement = true
        addParameterButton.accessibilityLabel = "Add Parameter"
        addParameterButton.accessibilityIdentifier = "add_parameter_button"
        addParameterButton.setTitle("+ Add Parameter", for: .normal)
        addParameterButton.translatesAutoresizingMaskIntoConstraints = false
        return addParameterButton
    }()

    private let sendEventButton: DynamicFontAwareButton = {
        let sendEventButton = DynamicFontAwareButton(type: .system)
        sendEventButton.style(with: .primary)
        sendEventButton.isAccessibilityElement = true
        sendEventButton.accessibilityLabel = "Send Event"
        sendEventButton.accessibilityIdentifier = "send_event_button"
        sendEventButton.setTitle("Send Event", for: .normal)
        sendEventButton.translatesAutoresizingMaskIntoConstraints = false
        return sendEventButton
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Custom Event"
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

        // Name Section
        let eventNameLabel = createSectionLabel(text: "Name")
        contentView.addArrangedSubview(eventNameLabel)
        attachToolbar(to: eventNameTextField)
        contentView.addArrangedSubview(eventNameTextField)

        // Parameters Section
        let parametersLabel = createSectionLabel(text: "Parameters")
        contentView.addArrangedSubview(parametersLabel)

        // Add Parameter Button
        addParameterButton.addTarget(self, action: #selector(addParameterRow), for: .touchUpInside)
        contentView.addArrangedSubview(addParameterButton)

        // Spacer
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentView.addArrangedSubview(spacerView)

        // Send Event Button
        sendEventButton.addTarget(self, action: #selector(sendEventButtonPressed), for: .touchUpInside)
        contentView.addArrangedSubview(sendEventButton)

        // Add initial parameter row
        addParameterRow()

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

            eventNameTextField.heightAnchor.constraint(equalToConstant: 44),
            sendEventButton.heightAnchor.constraint(equalToConstant: 44)
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

    @objc private func addParameterRow() {
        let parameterView = ParameterView()
        parameterView.onDelete = { [unowned self] view in
            self.removeParameterRow(view)
        }
        parameterViews.append(parameterView)
        parameterView.setAccessibilityOrder(index: parameterViews.endIndex - 1)

        // Insert before the add button
        if let insertIndex = contentView.arrangedSubviews.firstIndex(of: addParameterButton) {
            contentView.insertArrangedSubview(parameterView, at: insertIndex)
        }
    }

    private func removeParameterRow(_ view: ParameterView) {
        guard !parameterViews.isEmpty else { return }

        if let index = parameterViews.firstIndex(of: view) {
            parameterViews.remove(at: index)
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

    @objc private func sendEventButtonPressed() {
        guard let eventName = eventNameTextField.text, !eventName.isEmpty else {
            return
        }
        // Create the event
        let event = Insider.tagEvent(eventName)!

        // Add parameters
        for view in parameterViews {
            guard let (key, value, type) = view.getParameter() else {
                continue
            }
            switch type {
            case .string:
                event.addParameterWithString()(key, value)
            case .integer:
                if let intValue = Int(value) {
                    event.addParameterWithInt()(key, intValue)
                }
            case .double:
                if let doubleValue = Double(value) {
                    event.addParameterWithDouble()(key, doubleValue)
                }
            case .boolean:
                if ["yes", "true", "1"].contains(value.lowercased()) {
                    event.addParameterWithBoolean()(key, true)
                } else {
                    event.addParameterWithBoolean()(key, false)
                }
            }
        }
        // Build and send the event
        event.build()
    }
}

// MARK: - ParameterView

private final class ParameterView: UIView {

    public enum ParameterType: String, CaseIterable {
        case string = "String"
        case integer = "Integer"
        case double = "Double"
        case boolean = "Boolean"
    }

    public var onDelete: ((ParameterView) -> Void)?

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
        keyTextField.accessibilityLabel = "Parameter Name Input"
        keyTextField.placeholder = "Name"
        keyTextField.autocapitalizationType = .none
        keyTextField.autocorrectionType = .no
        keyTextField.clearButtonMode = .whileEditing
        return keyTextField
    }()

    private let typeSegmentedControl: UISegmentedControl = {
        let items = ParameterType.allCases.map { $0.rawValue }
        let typeSegmentedControl = UISegmentedControl(items: items)
        typeSegmentedControl.isAccessibilityElement = true
        typeSegmentedControl.accessibilityLabel = "Parameter Type Select"

        typeSegmentedControl.selectedSegmentIndex = 0
        return typeSegmentedControl
    }()

    private let valueTextField: PaddingAwareTextField = {
        let valueTextField = PaddingAwareTextField()
        valueTextField.style(with: .default)
        valueTextField.isAccessibilityElement = true
        valueTextField.accessibilityLabel = "Parameter Value Input"
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
        deleteButton.accessibilityLabel = "Delete Parameter"
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

    public func getParameter() -> (String, String, ParameterType)? {
        guard let key = keyTextField.text, !key.isEmpty,
              let value = valueTextField.text, !value.isEmpty else {
            return nil
        }
        let type = ParameterType.allCases[typeSegmentedControl.selectedSegmentIndex]
        return (key, value, type)
    }

    public func clear() {
        keyTextField.text = ""
        valueTextField.text = ""
        typeSegmentedControl.selectedSegmentIndex = 0
    }

    public func setAccessibilityOrder(index: Int) {
        let accessibilityIdentifier = "parameter_row_\(index)"
        self.accessibilityIdentifier = accessibilityIdentifier
        typeSegmentedControl.accessibilityIdentifier = "\(accessibilityIdentifier)_type_select"
        keyTextField.accessibilityIdentifier = "\(accessibilityIdentifier)_name_input"
        valueTextField.accessibilityIdentifier = "\(accessibilityIdentifier)_value_input"
        deleteButton.accessibilityIdentifier = "\(accessibilityIdentifier)_delete_button"
    }
}
