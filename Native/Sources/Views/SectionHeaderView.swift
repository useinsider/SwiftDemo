//
//  SectionHeaderView.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import UIKit

@MainActor public final class SectionHeaderView: UICollectionReusableView {

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.style(with: .heading2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupView() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public func configure(with title: String) {
        titleLabel.text = title
    }
}
