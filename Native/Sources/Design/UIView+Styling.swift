//
//  UIView+Styling.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

// MARK: - UIView

extension UIView: DesignStyleable {

    @discardableResult
    public func style(with builder: ((ViewStyleBuilder<UIView>) -> ())) -> Self {
        builder(ViewStyleBuilder<UIView>(view: self))
        return self
    }
}

// MARK: - UILabel

extension UILabel {

    @discardableResult
    public func style(with builder: ((LabelStyleBuilder) -> ())) -> Self {
        builder(LabelStyleBuilder(view: self))
        return self
    }
}

// MARK: - UIButton

extension DynamicFontAwareButton {

    @discardableResult
    public func style(with builder: ((ButtonStyleBuilder) -> ())) -> Self {
        builder(ButtonStyleBuilder(view: self))
        return self
    }
}

// MARK: - UITextField

extension PaddingAwareTextField {

    @discardableResult
    public func style(with builder: ((TextFieldStyleBuilder) -> ())) -> Self {
        builder(TextFieldStyleBuilder(view: self))
        return self
    }
}

// MARK: - UITextView

extension UITextView {

    @discardableResult
    public func style(with builder: ((TextViewStyleBuilder) -> ())) -> Self {
        builder(TextViewStyleBuilder(view: self))
        return self
    }
}

// MARK: - Convenience Extensions

extension UILabel {

    @discardableResult
    public func style(with variant: LabelStyleBuilder.Variant) -> Self {
        return style { $0.variant(variant) }
    }
}

extension DynamicFontAwareButton {

    @discardableResult
    public func style(with variant: ButtonStyleBuilder.Variant, size: ButtonStyleBuilder.Size = .large) -> Self {
        return style { $0.variant(variant, size: size) }
    }
}

extension PaddingAwareTextField {

    @discardableResult
    public func style(with variant: TextFieldStyleBuilder.Variant) -> Self {
        return style { $0.variant(variant) }
    }
}

extension UIView {

    @discardableResult
    public func style(with variant: ViewStyleBuilder<UIView>.Variant) -> Self {
        return style { $0.variant(variant) }
    }
}
