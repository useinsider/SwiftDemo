//
//  SmartRecommenderProductFormViewController.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import InsiderMobile
import UIKit

/// A form that builds an `InsiderProduct` from the `createNewProduct` arguments and the optional setters.
public final class SmartRecommenderProductFormViewController: UIViewController {

    /// Called with the product and its "name (id)" title once the price is a number; a product the SDK rejects is
    /// still passed on, with " (invalid)" appended to its title.
    public var onCreate: ((InsiderProduct, String) -> Void)?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.backgroundColor = .backgroundPrimary
        scrollView.accessibilityIdentifier = "product_form_scroll_view"
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 24
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(inset: 16)
        return stackView
    }()

    private let idTextField = PaddingAwareTextField.makeInput(
        placeholder: "Product id",
        accessibilityIdentifier: "product_id_input"
    )

    private let nameTextField = PaddingAwareTextField.makeInput(
        placeholder: "Product name",
        accessibilityIdentifier: "product_name_input"
    )

    private let imageURLTextField: PaddingAwareTextField = {
        let imageURLTextField = PaddingAwareTextField.makeInput(
            placeholder: "https://…",
            accessibilityIdentifier: "product_image_url_input",
            keyboardType: .URL
        )
        imageURLTextField.text = "https://picsum.photos/200/300"
        return imageURLTextField
    }()

    private let priceTextField = PaddingAwareTextField.makeInput(
        placeholder: "Number",
        accessibilityIdentifier: "product_price_input",
        keyboardType: .numbersAndPunctuation
    )

    private let currencyTextField: PaddingAwareTextField = {
        let currencyTextField = PaddingAwareTextField.makeInput(
            placeholder: "e.g., TRY",
            accessibilityIdentifier: "product_currency_input"
        )
        currencyTextField.text = "TRY"
        return currencyTextField
    }()

    private let taxonomyListView = TextFieldListView(placeholder: "Taxonomy", accessibilityIdentifierPrefix: "product_taxonomy")

    private let optionalFieldsView = ProductOptionalFieldsView()

    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.style(with: .bodySmall)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.accessibilityIdentifier = "product_form_error_label"
        return errorLabel
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Product"
        // A swipe that dismisses the keyboard must not dismiss the sheet and drop what was typed.
        isModalInPresentation = true
        view.backgroundColor = .backgroundPrimary
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        setupNavigationItems()
        setupSections()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Setup

    private func setupNavigationItems() {
        let cancelItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        })
        cancelItem.accessibilityIdentifier = "product_form_cancel_button"
        navigationItem.leftBarButtonItem = cancelItem

        let createItem = UIBarButtonItem(title: "Create", primaryAction: UIAction { [weak self] _ in
            self?.createProduct()
        })
        createItem.style = .done
        createItem.accessibilityIdentifier = "product_form_create_button"
        navigationItem.rightBarButtonItem = createItem
    }

    private func setupSections() {
        let requiredSection = SectionCardView(title: "Required", accessibilityIdentifier: "product_required_section")
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "ID", input: idTextField))
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "Name", input: nameTextField))
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "Image URL", input: imageURLTextField))
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "Price", input: priceTextField))
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "Currency", input: currencyTextField))
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "Taxonomy", input: taxonomyListView))
        requiredSection.contentStackView.addArrangedSubview(errorLabel)

        let optionalSection = SectionCardView(
            title: "Optional",
            isCollapsible: true,
            accessibilityIdentifier: "product_optional_section"
        )
        optionalSection.contentStackView.addArrangedSubview(optionalFieldsView)

        [requiredSection, optionalSection].forEach(stackView.addArrangedSubview)
    }

    // MARK: - Product

    private func createProduct() {
        view.endEditing(true)

        let id = idTextField.trimmedText
        let name = nameTextField.trimmedText
        let imageURL = imageURLTextField.trimmedText
        let currency = currencyTextField.trimmedText
        let taxonomy = taxonomyListView.values

        guard let price = Double(priceTextField.trimmedText) else {
            showError("Price must be a number.")
            return
        }

        let product = Insider.createNewProduct(
            withID: id,
            name: name,
            taxonomy: taxonomy,
            imageURL: imageURL,
            price: price,
            currency: currency
        )
        optionalFieldsView.apply(to: product)
        let invalidNote = product.isProductValid() ? "" : " (invalid)"

        onCreate?(product, "\(name) (\(id))\(invalidNote)")
        dismiss(animated: true)
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        scrollView.scrollRectToVisible(errorLabel.convert(errorLabel.bounds, to: scrollView), animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SmartRecommenderProductFormViewController: UIGestureRecognizerDelegate {

    // A tap inside a text field brings up its edit menu (Paste); ending editing there would close it.
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var touchedView = touch.view
        while let currentView = touchedView {
            if currentView is UITextField { return false }
            touchedView = currentView.superview
        }
        return true
    }
}
