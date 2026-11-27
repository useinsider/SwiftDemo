//
//  LabeledInputView.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import UIKit

/// A caption above an input control.
@MainActor public final class LabeledInputView: UIStackView {

    public init(title: String, input: UIView) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 4
        alignment = .fill
        translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.style(with: .caption)
        titleLabel.text = title
        addArrangedSubview(titleLabel)
        addArrangedSubview(input)
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
