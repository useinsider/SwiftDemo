//
//  AppSmartRecommenderViewController.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import InsiderMobile
import UIKit

public final class AppSmartRecommenderViewController: UIViewController {

    private var products: [InsiderAppSmartRecommenderProductModel] = []

    private var productsReferenceId = ""

    private weak var activeTextField: UITextField?

    private var lastScrollViewHeight: CGFloat = 0

    // MARK: - Layout

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.backgroundColor = .backgroundPrimary
        scrollView.accessibilityIdentifier = "app_smart_recommender_scroll_view"
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 24
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(inset: 16)
        return stackView
    }()

    // MARK: - GDPR

    private let gdprSwitch: UISwitch = {
        let gdprSwitch = UISwitch()
        gdprSwitch.isOn = true
        gdprSwitch.accessibilityIdentifier = "gdpr_consent_switch"
        return gdprSwitch
    }()

    // MARK: - Required

    private let referenceIdTextField = PaddingAwareTextField.makeInput(
        placeholder: "e.g., home_top",
        accessibilityIdentifier: "reference_id_input"
    )

    private let currencyTextField: PaddingAwareTextField = {
        let currencyTextField = PaddingAwareTextField.makeInput(
            placeholder: "e.g., TRY",
            accessibilityIdentifier: "currency_input"
        )
        currencyTextField.text = "TRY"
        return currencyTextField
    }()

    private let localeTextField: PaddingAwareTextField = {
        let localeTextField = PaddingAwareTextField.makeInput(
            placeholder: "e.g., tr_TR",
            accessibilityIdentifier: "locale_input"
        )
        localeTextField.text = "tr_TR"
        return localeTextField
    }()

    // MARK: - Identifiers

    private let emailTextField = PaddingAwareTextField.makeInput(
        placeholder: "e.g., user@example.com",
        accessibilityIdentifier: "identifier_email_input"
    )

    private let phoneNumberTextField = PaddingAwareTextField.makeInput(
        placeholder: "e.g., +905551112233",
        accessibilityIdentifier: "identifier_phone_number_input"
    )

    private let userIdTextField = PaddingAwareTextField.makeInput(
        placeholder: "e.g., user-123",
        accessibilityIdentifier: "identifier_user_id_input"
    )

    private let customIdentifierKeyTextField = PaddingAwareTextField.makeInput(
        placeholder: "e.g., membership_id",
        accessibilityIdentifier: "identifier_custom_key_input"
    )

    private let customIdentifierValueTextField = PaddingAwareTextField.makeInput(
        placeholder: "e.g., M-42",
        accessibilityIdentifier: "identifier_custom_value_input"
    )

    // MARK: - Filters

    private let categoriesListView = TextFieldListView(placeholder: "Category", accessibilityIdentifierPrefix: "category")

    private let categoriesSendEmptySwitch: UISwitch = {
        let categoriesSendEmptySwitch = UISwitch()
        categoriesSendEmptySwitch.accessibilityIdentifier = "categories_send_empty_switch"
        return categoriesSendEmptySwitch
    }()

    private let productIdsListView = TextFieldListView(placeholder: "Product ID", accessibilityIdentifierPrefix: "product_id")

    private let productIdsSendEmptySwitch: UISwitch = {
        let productIdsSendEmptySwitch = UISwitch()
        productIdsSendEmptySwitch.accessibilityIdentifier = "product_ids_send_empty_switch"
        return productIdsSendEmptySwitch
    }()

    private let partnerFilterKeyTextField: PaddingAwareTextField = {
        let partnerFilterKeyTextField = PaddingAwareTextField.makeInput(
            placeholder: "e.g., custom_context",
            accessibilityIdentifier: "partner_filter_key_input"
        )
        partnerFilterKeyTextField.text = "custom_context"
        return partnerFilterKeyTextField
    }()

    private let partnerFilterValueTextField = PaddingAwareTextField.makeInput(
        placeholder: "e.g., partner",
        accessibilityIdentifier: "partner_filter_value_input"
    )

    private var createdProducts: [(product: InsiderProduct, title: String)] = []

    private let productDropdownButton = DropdownButton(
        options: ["None"],
        accessibilityIdentifier: "product_dropdown_button"
    )

    private let addProductButton: DynamicFontAwareButton = {
        let addProductButton = DynamicFontAwareButton(configuration: .filled())
        addProductButton.style(with: .secondary)
        addProductButton.setTitle("Add Product", for: .normal)
        addProductButton.isAccessibilityElement = true
        addProductButton.accessibilityTraits = .button
        addProductButton.accessibilityLabel = "Add Product"
        addProductButton.accessibilityIdentifier = "add_product_button"
        return addProductButton
    }()

    private let attributeConditionEditorView = AttributeConditionEditorView()

    // MARK: - Request and result

    private let getProductsButton: DynamicFontAwareButton = {
        let getProductsButton = DynamicFontAwareButton(configuration: .filled())
        getProductsButton.style(with: .primary)
        getProductsButton.setTitle("Get Products", for: .normal)
        getProductsButton.isAccessibilityElement = true
        getProductsButton.accessibilityTraits = .button
        getProductsButton.accessibilityLabel = "Get Products"
        getProductsButton.accessibilityIdentifier = "get_products_button"
        return getProductsButton
    }()

    private let resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.style(with: .bodySmall)
        resultLabel.numberOfLines = 0
        resultLabel.text = "No request sent yet."
        resultLabel.accessibilityIdentifier = "result_label"
        return resultLabel
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .textPrimary
        loadingIndicator.accessibilityIdentifier = "loading_indicator"
        return loadingIndicator
    }()

    private lazy var loadingBarButtonItem: UIBarButtonItem = {
        let loadingBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
        if #available(iOS 26.0, *) {
            // Without this the indicator sits on the bar's white glass bubble and is hard to see.
            loadingBarButtonItem.hidesSharedBackground = true
        }
        return loadingBarButtonItem
    }()

    private var inFlightRequestCount = 0 {
        didSet {
            if inFlightRequestCount > 0 {
                navigationItem.rightBarButtonItem = loadingBarButtonItem
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
                navigationItem.rightBarButtonItem = nil
            }
        }
    }

    private lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 280, height: 144)
        layout.minimumLineSpacing = 12
        let productsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        productsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productsCollectionView.backgroundColor = .clear
        productsCollectionView.showsHorizontalScrollIndicator = false
        productsCollectionView.alwaysBounceVertical = false
        productsCollectionView.alwaysBounceHorizontal = true
        productsCollectionView.accessibilityIdentifier = "products_collection_view"
        productsCollectionView.register(
            SmartRecommenderProductCell.self,
            forCellWithReuseIdentifier: SmartRecommenderProductCell.reuseIdentifier
        )
        productsCollectionView.dataSource = self
        return productsCollectionView
    }()

    private let viewProductsButton: DynamicFontAwareButton = {
        let viewProductsButton = DynamicFontAwareButton(configuration: .filled())
        viewProductsButton.style(with: .secondary)
        viewProductsButton.setTitle("View Products", for: .normal)
        viewProductsButton.isAccessibilityElement = true
        viewProductsButton.accessibilityTraits = .button
        viewProductsButton.accessibilityLabel = "View Products"
        viewProductsButton.accessibilityIdentifier = "view_products_button"
        return viewProductsButton
    }()

    private let viewWidgetButton: DynamicFontAwareButton = {
        let viewWidgetButton = DynamicFontAwareButton(configuration: .filled())
        viewWidgetButton.style(with: .secondary)
        viewWidgetButton.setTitle("View Widget", for: .normal)
        viewWidgetButton.isAccessibilityElement = true
        viewWidgetButton.accessibilityTraits = .button
        viewWidgetButton.accessibilityLabel = "View Widget"
        viewWidgetButton.accessibilityIdentifier = "view_widget_button"
        return viewWidgetButton
    }()

    private let clickWidgetButton: DynamicFontAwareButton = {
        let clickWidgetButton = DynamicFontAwareButton(configuration: .filled())
        clickWidgetButton.style(with: .secondary)
        clickWidgetButton.setTitle("Click Widget", for: .normal)
        clickWidgetButton.isAccessibilityElement = true
        clickWidgetButton.accessibilityTraits = .button
        clickWidgetButton.accessibilityLabel = "Click Widget"
        clickWidgetButton.accessibilityIdentifier = "click_widget_button"
        return clickWidgetButton
    }()

    private let lastActionLabel: UILabel = {
        let lastActionLabel = UILabel()
        lastActionLabel.style(with: .bodySmall)
        lastActionLabel.numberOfLines = 0
        lastActionLabel.text = "Last action: none"
        lastActionLabel.accessibilityIdentifier = "last_action_label"
        return lastActionLabel
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "App Smart Recommender"
        view.backgroundColor = .backgroundPrimary
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        setupSections()
        setupActions()
        setupKeyboardHandling()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            productsCollectionView.heightAnchor.constraint(equalToConstant: 144)
        ])
    }

    // The keyboard layout guide resizes the scroll view inside the keyboard animation; the focused field is
    // scrolled into view on the next run loop turn, once the new height is in place.
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard scrollView.bounds.height != lastScrollViewHeight else { return }

        lastScrollViewHeight = scrollView.bounds.height
        DispatchQueue.main.async { [weak self] in
            self?.scrollActiveTextFieldIntoView()
        }
    }

    // MARK: - Setup

    private func setupSections() {
        let gdprSection = SectionCardView(title: "GDPR", accessibilityIdentifier: "gdpr_section")
        gdprSection.contentStackView.addArrangedSubview(makeSwitchRow(title: "GDPR Consent", switchControl: gdprSwitch))

        let requiredSection = SectionCardView(title: "Required", accessibilityIdentifier: "required_section")
        requiredSection.contentStackView.addArrangedSubview(
            LabeledInputView(title: "Reference ID", input: referenceIdTextField)
        )
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "Currency", input: currencyTextField))
        requiredSection.contentStackView.addArrangedSubview(LabeledInputView(title: "Locale", input: localeTextField))

        let identifiersSection = SectionCardView(
            title: "Identifiers",
            isCollapsible: true,
            accessibilityIdentifier: "identifiers_section"
        )
        [
            LabeledInputView(title: "Email", input: emailTextField),
            LabeledInputView(title: "Phone Number", input: phoneNumberTextField),
            LabeledInputView(title: "User ID", input: userIdTextField),
            LabeledInputView(title: "Custom Identifier Key", input: customIdentifierKeyTextField),
            LabeledInputView(title: "Custom Identifier Value", input: customIdentifierValueTextField)
        ].forEach(identifiersSection.contentStackView.addArrangedSubview)

        let categoriesSection = SectionCardView(
            title: "Categories",
            isCollapsible: true,
            accessibilityIdentifier: "categories_section"
        )
        categoriesSection.contentStackView.addArrangedSubview(categoriesListView)
        categoriesSection.contentStackView.addArrangedSubview(
            makeSwitchRow(title: "Send even if empty", switchControl: categoriesSendEmptySwitch)
        )

        let productIdsSection = SectionCardView(
            title: "Product IDs",
            isCollapsible: true,
            accessibilityIdentifier: "product_ids_section"
        )
        productIdsSection.contentStackView.addArrangedSubview(productIdsListView)
        productIdsSection.contentStackView.addArrangedSubview(
            makeSwitchRow(title: "Send even if empty", switchControl: productIdsSendEmptySwitch)
        )

        let productSection = SectionCardView(title: "Product", isCollapsible: true, accessibilityIdentifier: "product_section")
        productSection.contentStackView.addArrangedSubview(
            LabeledInputView(title: "Product", input: productDropdownButton)
        )
        productSection.contentStackView.addArrangedSubview(addProductButton)

        let conditionsSection = SectionCardView(
            title: "Attribute Conditions",
            isCollapsible: true,
            accessibilityIdentifier: "attribute_conditions_section"
        )
        conditionsSection.contentStackView.addArrangedSubview(attributeConditionEditorView)

        let partnerFilterSection = SectionCardView(
            title: "Partner Filter",
            isCollapsible: true,
            accessibilityIdentifier: "partner_filter_section"
        )
        partnerFilterSection.contentStackView.addArrangedSubview(
            LabeledInputView(title: "Key", input: partnerFilterKeyTextField)
        )
        partnerFilterSection.contentStackView.addArrangedSubview(
            LabeledInputView(title: "Value", input: partnerFilterValueTextField)
        )

        let getProductsSection = SectionCardView(title: nil, accessibilityIdentifier: "get_products_section")
        getProductsSection.contentStackView.addArrangedSubview(getProductsButton)

        let resultSection = SectionCardView(title: "Result", accessibilityIdentifier: "result_section")
        resultSection.contentStackView.addArrangedSubview(resultLabel)

        let productsSection = SectionCardView(title: "Products", accessibilityIdentifier: "products_section")
        productsSection.contentStackView.addArrangedSubview(productsCollectionView)
        productsSection.contentStackView.addArrangedSubview(viewProductsButton)
        let widgetButtonsRow = UIStackView(arrangedSubviews: [viewWidgetButton, clickWidgetButton])
        widgetButtonsRow.axis = .horizontal
        widgetButtonsRow.distribution = .fillEqually
        widgetButtonsRow.spacing = 8
        productsSection.contentStackView.addArrangedSubview(widgetButtonsRow)
        productsSection.contentStackView.addArrangedSubview(lastActionLabel)

        [
            gdprSection,
            requiredSection,
            identifiersSection,
            categoriesSection,
            productIdsSection,
            productSection,
            conditionsSection,
            partnerFilterSection,
            getProductsSection,
            resultSection,
            productsSection
        ].forEach(stackView.addArrangedSubview)
    }

    private func makeSwitchRow(title: String, switchControl: UISwitch) -> UIStackView {
        let label = UILabel()
        label.style(with: .bodySmall)
        label.text = title
        let row = UIStackView(arrangedSubviews: [label, switchControl])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        return row
    }

    private func setupActions() {
        gdprSwitch.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            Insider.setGDPRConsent(self.gdprSwitch.isOn)
        }, for: .valueChanged)
        getProductsButton.addAction(UIAction { [weak self] _ in self?.getProducts() }, for: .touchUpInside)
        addProductButton.addAction(UIAction { [weak self] _ in self?.presentProductForm() }, for: .touchUpInside)
        viewProductsButton.addAction(UIAction { [weak self] _ in self?.viewVisibleProducts() }, for: .touchUpInside)
        viewWidgetButton.addAction(UIAction { [weak self] _ in self?.viewWidget() }, for: .touchUpInside)
        clickWidgetButton.addAction(UIAction { [weak self] _ in self?.clickWidget() }, for: .touchUpInside)
    }

    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidBeginEditing(_:)),
            name: UITextField.textDidBeginEditingNotification,
            object: nil
        )
    }

    // MARK: - Keyboard

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func textFieldDidBeginEditing(_ notification: Notification) {
        guard let textField = notification.object as? UITextField, textField.isDescendant(of: view) else { return }

        activeTextField = textField
        scrollActiveTextFieldIntoView()
    }

    private func scrollActiveTextFieldIntoView() {
        guard let activeTextField, activeTextField.isFirstResponder else { return }

        // scrollRectToVisible(_:animated:) left the offset untouched here on iOS 26, so the offset is set directly.
        let rect = activeTextField.convert(activeTextField.bounds, to: scrollView).insetBy(dx: 0, dy: -16)
        let visibleRect = scrollView.bounds
        let maxOffsetY = max(0, scrollView.contentSize.height - visibleRect.height)
        var offsetY = visibleRect.minY
        if rect.maxY > visibleRect.maxY {
            offsetY = rect.maxY - visibleRect.height
        } else if rect.minY < visibleRect.minY {
            offsetY = rect.minY
        }
        offsetY = min(max(0, offsetY), maxOffsetY)
        guard offsetY != visibleRect.minY else { return }

        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }

    // MARK: - Request

    private func getProducts() {
        dismissKeyboard()
        resultLabel.text = nil
        lastActionLabel.text = "Last action: none"
        products = []
        productsCollectionView.reloadData()

        let query = InsiderAppSmartRecommenderQuery(currency: currencyTextField.trimmedText, filters: makeFilters())
        let referenceId = referenceIdTextField.trimmedText
        productsReferenceId = referenceId
        let locale = localeTextField.trimmedText
        let identifiers = makeIdentifiers()
        let recommender = Insider.appSmartRecommender()
        inFlightRequestCount += 1

        Task { @MainActor in
            do {
                let response: InsiderAppSmartRecommenderProductsResponseModel
                switch (locale.isEmpty, identifiers) {
                case (true, nil):
                    response = try await recommender.getProducts(referenceId: referenceId, query: query)
                case (false, nil):
                    response = try await recommender.getProducts(referenceId: referenceId, locale: locale, query: query)
                case (true, let identifiers?):
                    response = try await recommender.getProducts(referenceId: referenceId,
                                                                 identifiers: identifiers,
                                                                 query: query)
                case (false, let identifiers?):
                    response = try await recommender.getProducts(referenceId: referenceId,
                                                                 locale: locale,
                                                                 identifiers: identifiers,
                                                                 query: query)
                }
                self.show(response)
            } catch {
                self.resultLabel.text = self.describe(error)
            }
            self.inFlightRequestCount -= 1
            self.productsCollectionView.reloadData()
            self.productsCollectionView.setContentOffset(.zero, animated: false)
        }
    }

    private func makeFilters() -> [any InsiderAppSmartRecommenderFilterProtocol] {
        var filters: [any InsiderAppSmartRecommenderFilterProtocol] = []

        if let product = makeProduct() {
            filters.append(InsiderAppSmartRecommenderProductFilter(product: product))
        }

        let productIds = productIdsListView.values
        if !productIds.isEmpty || productIdsSendEmptySwitch.isOn {
            filters.append(InsiderAppSmartRecommenderProductsFilter(productIds: productIds))
        }

        let categories = categoriesListView.values
        if !categories.isEmpty || categoriesSendEmptySwitch.isOn {
            filters.append(InsiderAppSmartRecommenderCategoriesFilter(categories: categories))
        }

        let conditions = attributeConditionEditorView.conditions
        if !conditions.isEmpty {
            filters.append(InsiderAppSmartRecommenderAttributesFilter(conditions: conditions))
        }

        let partnerFilterValue = partnerFilterValueTextField.text ?? ""
        if !partnerFilterValue.isEmpty {
            filters.append(PartnerContextFilter(key: partnerFilterKeyTextField.text ?? "", value: partnerFilterValue))
        }

        return filters
    }

    private func makeIdentifiers() -> InsiderIdentifiers? {
        let email = emailTextField.trimmedText
        let phoneNumber = phoneNumberTextField.trimmedText
        let userId = userIdTextField.trimmedText
        let customKey = customIdentifierKeyTextField.trimmedText
        let customValue = customIdentifierValueTextField.trimmedText
        let hasCustomIdentifier = !customKey.isEmpty && !customValue.isEmpty
        guard !email.isEmpty || !phoneNumber.isEmpty || !userId.isEmpty || hasCustomIdentifier else { return nil }

        let identifiers = InsiderIdentifiers()
        if !email.isEmpty {
            _ = identifiers.addEmail()(email)
        }
        if !phoneNumber.isEmpty {
            _ = identifiers.addPhoneNumber()(phoneNumber)
        }
        if !userId.isEmpty {
            _ = identifiers.addUserID()(userId)
        }
        if hasCustomIdentifier {
            _ = identifiers.addCustomIdentifier()(customKey, customValue)
        }
        return identifiers
    }

    // Index 0 of the dropdown is "None"; the created products follow in creation order.
    private func makeProduct() -> InsiderProduct? {
        let index = productDropdownButton.selectedIndex - 1
        return createdProducts.indices.contains(index) ? createdProducts[index].product : nil
    }

    private func presentProductForm() {
        view.endEditing(true)

        let form = SmartRecommenderProductFormViewController()
        form.onCreate = { [weak self] product, title in
            self?.add(product, title: title)
        }
        let navigation = UINavigationController(rootViewController: form)
        navigation.modalPresentationStyle = .pageSheet
        if let sheet = navigation.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(navigation, animated: true)
    }

    private func add(_ product: InsiderProduct, title: String) {
        createdProducts.append((product, title))
        productDropdownButton.setOptions(["None"] + createdProducts.map(\.title), selectedIndex: createdProducts.count)
    }

    // MARK: - Result

    private func show(_ response: InsiderAppSmartRecommenderProductsResponseModel) {
        resultLabel.text = describe(response)
        products = response.products ?? []
        if let referenceId = response.context?.referenceId, !referenceId.isEmpty {
            productsReferenceId = referenceId
        }
    }

    // MARK: - Events

    private func click(_ product: InsiderAppSmartRecommenderProductModel) {
        let insiderProduct = Insider.createNewProduct(
            withID: product.productId,
            name: product.name,
            taxonomy: product.categories,
            imageURL: product.imageUrl ?? "",
            price: product.price,
            currency: product.currency
        )
        if let groupCode = product.groupCode, !groupCode.isEmpty {
            insiderProduct.setGroupCode()(groupCode)
        }
        Insider.appSmartRecommender().click(referenceId: productsReferenceId, product: insiderProduct)

        let invalidNote = insiderProduct.isProductValid() ? "" : " (invalid product)"
        showLastAction("click \(product.productId)\(invalidNote)")
    }

    // A product counts as visible when any part of its cell is on screen.
    private func viewVisibleProducts() {
        let visibleProducts = productsCollectionView.indexPathsForVisibleItems
            .map(\.item)
            .sorted()
            .filter { products.indices.contains($0) }
            .map { products[$0] }
        Insider.appSmartRecommender().view(products: visibleProducts)

        let productIds = visibleProducts.map(\.productId).joined(separator: ", ")
        showLastAction("view \(productIds.isEmpty ? "no products" : productIds)")
    }

    private var rawReferenceId: String {
        return referenceIdTextField.text ?? ""
    }

    private func viewWidget() {
        Insider.appSmartRecommender().viewWidget(referenceId: rawReferenceId)
        showLastAction("view widget", referenceId: rawReferenceId)
    }

    private func clickWidget() {
        Insider.appSmartRecommender().clickWidget(referenceId: rawReferenceId)
        showLastAction("click widget", referenceId: rawReferenceId)
    }

    private func showLastAction(_ action: String, referenceId: String? = nil) {
        let shownReferenceId = referenceId ?? productsReferenceId
        let referenceIdText = shownReferenceId.isEmpty ? "empty reference id" : shownReferenceId
        lastActionLabel.text = "Last action: \(action) · \(referenceIdText)"
    }

    private func describe(_ response: InsiderAppSmartRecommenderProductsResponseModel) -> String {
        return [
            "outcome: \(response.outcome?.rawValue ?? "nil")",
            "reason: \(response.reason ?? "nil")",
            "requestId: \(response.context?.requestId ?? "nil")",
            "referenceId: \(response.context?.referenceId ?? "nil")",
            "locale: \(response.context?.locale ?? "nil")",
            "currency: \(response.context?.currency ?? "nil")",
            "campaignId: \(response.context?.campaignId ?? 0)",
            "variantId: \(response.context?.variantId ?? 0)",
            "isControlGroup: \(response.context?.isControlGroup ?? false)",
            "products: \(response.products?.count ?? 0)"
        ].joined(separator: "\n")
    }

    private func describe(_ error: Error) -> String {
        let nsError = error as NSError
        var lines = [
            "domain: \(nsError.domain)",
            "code: \(nsError.code)\(codeName(of: nsError).map { " (\($0))" } ?? "")",
            "localizedDescription: \(nsError.localizedDescription)"
        ]

        if let recommenderError = nsError as? InsiderAppSmartRecommenderError {
            lines.append("serverCode: \(recommenderError.serverCode ?? "nil")")
            lines.append("cause: \(recommenderError.cause ?? "nil")")
            lines.append(recommenderError.errors.isEmpty ? "errors: none" : "errors:")
            for entry in recommenderError.errors {
                let fields = entry.keys.sorted().map { key in
                    return "\(key)=\(entry[key].map { "\($0)" } ?? "nil")"
                }
                lines.append("  - \(fields.joined(separator: ", "))")
            }
        }

        if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
            lines.append(
                "underlying: \(underlyingError.domain)#\(underlyingError.code) \(underlyingError.localizedDescription)"
            )
        }
        return lines.joined(separator: "\n")
    }

    private func codeName(of error: NSError) -> String? {
        guard error.domain == InsiderAppSmartRecommenderErrorDomain,
              let code = InsiderAppSmartRecommenderErrorCode.Code(rawValue: error.code) else {
            return nil
        }

        switch code {
        case .sdkNotInitialized: return "sdkNotInitialized"
        case .invalidParameter: return "invalidParameter"
        case .serverError: return "serverError"
        case .timeout: return "timeout"
        case .networkError: return "networkError"
        case .parseError: return "parseError"
        case .notEnabled: return "notEnabled"
        case .gdprOptedOut: return "gdprOptedOut"
        case .sessionNotStarted: return "sessionNotStarted"
        @unknown default: return nil
        }
    }
}

extension AppSmartRecommenderViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SmartRecommenderProductCell.reuseIdentifier,
            for: indexPath
        )
        let product = products[indexPath.item]
        if let productCell = cell as? SmartRecommenderProductCell {
            productCell.configure(with: product, index: indexPath.item)
            productCell.onClick = { [weak self] in self?.click(product) }
        }
        return cell
    }
}

extension AppSmartRecommenderViewController: UIGestureRecognizerDelegate {

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
