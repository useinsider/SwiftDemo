//
//  AppFramesViewController.swift
//  Example
//
//  Created by Heysem on 20.06.2026.
//

import InsiderMobile
import UIKit

public final class AppFramesViewController: UIViewController {

    /// Sections in display order. Delegate callbacks resolve their section from here rather than walking the view hierarchy.
    private var sections: [AppFrameSectionView] = []

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .backgroundPrimary
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

    private let consentCardView: UIView = {
        let consentCardView = UIView()
        consentCardView.style { $0.variant(.card) }
        consentCardView.translatesAutoresizingMaskIntoConstraints = false
        return consentCardView
    }()

    private let consentStackView: UIStackView = {
        let consentStackView = UIStackView()
        consentStackView.translatesAutoresizingMaskIntoConstraints = false
        consentStackView.axis = .vertical
        consentStackView.spacing = 14
        consentStackView.alignment = .fill
        consentStackView.isLayoutMarginsRelativeArrangement = true
        consentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(inset: 16)
        return consentStackView
    }()

    private let gdprConsentButtonRow = makeConsentButtonRow(actions: [
        AnyAction(SetGDPRAction(enabled: true)),
        AnyAction(SetGDPRAction(enabled: false))
    ])

    private let mobileAppAccessButtonRow = makeConsentButtonRow(actions: [
        AnyAction(SetMobileAppAccessAction(enabled: true)),
        AnyAction(SetMobileAppAccessAction(enabled: false))
    ])

    private static func makeConsentButton(action: AnyAction) -> DynamicFontAwareButton {
        let consentButton = DynamicFontAwareButton(configuration: .filled())
        consentButton.style(with: .primary)
        consentButton.configuration?.titleLineBreakMode = .byWordWrapping
        consentButton.configuration?.titleAlignment = .center
        consentButton.setTitle(action.title, for: .normal)
        consentButton.addAction(UIAction { _ in action.execute() }, for: .touchUpInside)
        consentButton.isAccessibilityElement = true
        consentButton.accessibilityTraits = .button
        consentButton.accessibilityLabel = action.title
        consentButton.accessibilityIdentifier = "\(action.accessibilityIdentifier)_button"
        consentButton.translatesAutoresizingMaskIntoConstraints = false
        return consentButton
    }

    private static func makeConsentButtonRow(actions: [AnyAction]) -> UIStackView {
        let consentButtonRow = UIStackView(arrangedSubviews: actions.map(makeConsentButton))
        consentButtonRow.translatesAutoresizingMaskIntoConstraints = false
        consentButtonRow.axis = .horizontal
        consentButtonRow.distribution = .fillEqually
        consentButtonRow.alignment = .fill
        consentButtonRow.spacing = 12
        return consentButtonRow
    }

    private let placementIdTextField: PaddingAwareTextField = {
        let placementIdTextField = PaddingAwareTextField()
        placementIdTextField.style(with: .default)
        placementIdTextField.isAccessibilityElement = true
        placementIdTextField.accessibilityLabel = "Placement ID Input"
        placementIdTextField.accessibilityIdentifier = "placement_id_input"
        placementIdTextField.placeholder = "e.g., home_page"
        placementIdTextField.autocapitalizationType = .none
        placementIdTextField.autocorrectionType = .no
        placementIdTextField.clearButtonMode = .whileEditing
        placementIdTextField.returnKeyType = .done
        placementIdTextField.translatesAutoresizingMaskIntoConstraints = false
        return placementIdTextField
    }()

    private let addPlacementButton: DynamicFontAwareButton = {
        let addPlacementButton = DynamicFontAwareButton(type: .system)
        addPlacementButton.style(with: .primary)
        addPlacementButton.setTitle("+ Add Placement", for: .normal)
        addPlacementButton.isAccessibilityElement = true
        addPlacementButton.accessibilityLabel = "Add Placement"
        addPlacementButton.accessibilityIdentifier = "add_placement_button"
        addPlacementButton.translatesAutoresizingMaskIntoConstraints = false
        return addPlacementButton
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "App Frames"
        view.backgroundColor = .backgroundPrimary
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(consentCardView)
        stackView.addArrangedSubview(placementIdTextField)
        stackView.addArrangedSubview(addPlacementButton)

        consentCardView.addSubview(consentStackView)
        consentStackView.addArrangedSubview(gdprConsentButtonRow)
        consentStackView.addArrangedSubview(mobileAppAccessButtonRow)

        placementIdTextField.delegate = self
        addPlacementButton.addTarget(self, action: #selector(addPlacementTapped), for: .touchUpInside)
        setupKeyboardDismissal()

        NSLayoutConstraint.activate([
            consentStackView.topAnchor.constraint(equalTo: consentCardView.topAnchor),
            consentStackView.leadingAnchor.constraint(equalTo: consentCardView.leadingAnchor),
            consentStackView.trailingAnchor.constraint(equalTo: consentCardView.trailingAnchor),
            consentStackView.bottomAnchor.constraint(equalTo: consentCardView.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            placementIdTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func addPlacementTapped() {
        addPlacement()
    }

    private func addPlacement() {
        let placementId = (placementIdTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        placementIdTextField.text = nil
        dismissKeyboard()

        guard !placementId.isEmpty else { return }

        stackView.addArrangedSubview(makeFrameSection(placementId: placementId))
    }

    private func makeFrameSection(placementId: String) -> AppFrameSectionView {
        let section = AppFrameSectionView(placementId: placementId)
        section.framesView.delegate = self
        section.onDelete = { [weak self] section in
            self?.remove(section)
        }
        sections.append(section)
        section.setAccessibilityOrder(index: sections.endIndex - 1)
        return section
    }

    private func remove(_ section: AppFrameSectionView) {
        guard let index = sections.firstIndex(where: { $0 === section }) else { return }

        sections.remove(at: index)
        stackView.removeArrangedSubview(section)
        section.removeFromSuperview()

        for (index, section) in sections.enumerated() {
            section.setAccessibilityOrder(index: index)
        }
    }

    private func section(for framesView: InsiderAppFramesView) -> AppFrameSectionView? {
        return sections.first { $0.framesView === framesView }
    }

    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    /// Names the `InsiderAppFramesErrorCode` behind `error`, appending the underlying failure when present.
    private func describe(_ error: Error) -> String {
        let nsError = error as NSError
        guard nsError.domain == InsiderAppFramesErrorDomain,
              let code = InsiderAppFramesError.Code(rawValue: nsError.code) else {
            return "\(nsError.domain)#\(nsError.code)"
        }

        let name: String
        switch code {
        case .unknown: name = "unknown"
        case .resolutionFailed: name = "resolutionFailed"
        case .responseMalformed: name = "responseMalformed"
        case .downloadingFailed: name = "downloadingFailed"
        case .placementUntrusted: name = "placementUntrusted"
        case .contentDisplayFailed: name = "contentDisplayFailed"
        case .renderingFailed: name = "renderingFailed"
        @unknown default: name = "unknown(\(nsError.code))"
        }

        guard let underlying = nsError.userInfo[NSUnderlyingErrorKey] as? NSError else {
            return name
        }
        return "\(name) — \(underlying.localizedDescription)"
    }

    private func prettyPrinted(_ actionData: [String: Any]) -> String {
        guard JSONSerialization.isValidJSONObject(actionData),
              let data = try? JSONSerialization.data(withJSONObject: actionData,
                                                     options: [.prettyPrinted, .sortedKeys]),
              let json = String(data: data, encoding: .utf8) else {
            return String(describing: actionData)
        }
        return json
    }
}

extension AppFramesViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addPlacement()
        return true
    }
}

extension AppFramesViewController: InsiderAppFramesViewDelegate {

    public func appFramesView(_ view: InsiderAppFramesView,
                              didChangeStatusTo status: InsiderAppFramesViewStatus,
                              from previousStatus: InsiderAppFramesViewStatus) {
        section(for: view)?.record(.statusChange(status, from: previousStatus))
    }

    public func appFramesView(_ view: InsiderAppFramesView, didFailLoading error: any Error) {
        section(for: view)?.record(.failed(describe(error)))
    }

    public func appFramesView(_ view: InsiderAppFramesView, didRequestHeightChangeTo optimalHeight: CGFloat) {
        section(for: view)?.record(.heightChange(optimalHeight))
    }

    public func appFramesViewDidRequestDismiss(_ view: InsiderAppFramesView) {
        guard let section = section(for: view) else { return }

        remove(section)
    }

    public func appFramesView(_ view: InsiderAppFramesView, didTriggerAction actionData: [String: Any]) {
        section(for: view)?.record(.action)

        Alert(title: "Frame Action", message: prettyPrinted(actionData)) {
            AlertAction(title: "Close", style: .cancel)
        }.show(on: self)
    }
}
