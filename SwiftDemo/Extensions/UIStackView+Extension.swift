//
//  UIStackView+Extension.swift
//  SwiftDemo
//
//  Created by Zahide Sena Kurtak on 9.02.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView] ) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func addPadding(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
