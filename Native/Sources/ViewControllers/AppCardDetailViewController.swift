//
//  AppCardDetailViewController.swift
//  Example
//
//  Created by Insider on 26.03.2026.
//

import UIKit
import InsiderMobile

public final class AppCardDetailViewController: UIViewController {

    private let message: InsiderAppCardModel

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(inset: 10)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        return contentStackView
    }()

    private let contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.isAccessibilityElement = true
        contentTextView.accessibilityIdentifier = "messageDetailContentTextView"
        contentTextView.accessibilityLabel = "Content"
        contentTextView.style { style in
            style
                .backgroundColor(.backgroundPrimary)
                .font(.text16)
                .textColor(.textPrimary)
        }
        contentTextView.isEditable = false
        contentTextView.isSelectable = true
        contentTextView.isScrollEnabled = false
        contentTextView.textContainerInset = .zero
        contentTextView.textContainer.lineFragmentPadding = 0
        return contentTextView
    }()

    public init(message: InsiderAppCardModel) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        self.message = InsiderAppCardModel()
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
        configureContent()
    }

    public override func loadView() {
        super.loadView()
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(contentTextView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func configureContent() {
        contentTextView.text = message.toInsiderJSONString().replacingOccurrences(of: "\\/", with: "/")
        contentTextView.accessibilityValue = contentTextView.text
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
