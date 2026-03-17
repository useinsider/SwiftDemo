//
//  TextFieldStyleBuilder.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public final class TextFieldStyleBuilder: ViewStyleBuilder<PaddingAwareTextField> {

    public enum Variant {
        case `default`
        case error
        case disabled
    }

    @discardableResult
    public func font(_ font: Font) -> Self {
        view?.font = .scaledFont(font)
        view?.adjustsFontForContentSizeCategory = true
        return self
    }

    @discardableResult
    public func textColor(_ color: UIColor) -> Self {
        view?.textColor = color
        return self
    }

    @discardableResult
    public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        view?.textAlignment = alignment
        return self
    }

    @discardableResult
    public func padding(_ padding: UIEdgeInsets) -> Self {
        view?.padding = padding
        return self
    }

    @discardableResult
    public func backgroundImage(_ image: UIImage?) -> Self {
        view?.background = image
        return self
    }

    @discardableResult
    public func variant(_ variant: Variant) -> Self {
        switch variant {
        case .default:
            return applyDefaultStyle()
        case .error:
            return applyErrorStyle()
        case .disabled:
            return applyDisabledStyle()
        }
    }

    private func applyDefaultStyle() -> Self {
        return self
            .font(.text16)
            .textColor(.textPrimary)
            .borderColor(.borderSubtle, width: 0.75)
            .backgroundColor(.surfacePrimary)
            .padding(UIEdgeInsets(left: 5.0))
            .cornerRadius(5.0)
    }

    private func applyErrorStyle() -> Self {
        return self
            .font(.text16)
            .textColor(.textPrimary)
            .backgroundColor(.surfacePrimary)
            .borderColor(.statusDanger, width: 0.75)
            .padding(UIEdgeInsets(left: 5.0))
            .cornerRadius(5.0)
    }

    private func applyDisabledStyle() -> Self {
        return self
            .font(.text16)
            .textColor(.textDisabled)
            .backgroundColor(.surfacePrimary)
            .borderColor(.borderSubtle, width: 0.75)
            .padding(UIEdgeInsets(left: 5.0))
            .cornerRadius(5.0)
            .alpha(0.7)
    }
}
