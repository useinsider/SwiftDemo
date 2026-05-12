//
//  PaddingAwareTextField.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public final class PaddingAwareTextField: UITextField {

    public var padding = UIEdgeInsets.zero {
        didSet {
            setNeedsLayout()
        }
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
