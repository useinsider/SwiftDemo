//
//  LabelStyleBuilder.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public final class LabelStyleBuilder: ViewStyleBuilder<UILabel> {

    public enum Variant {
        case heading1
        case heading2
        case heading3
        case heading4
        case heading5
        case heading6
        case body
        case bodySmall
        case caption
        case highlight
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
    public func numberOfLines(_ lines: Int) -> Self {
        view?.numberOfLines = lines
        return self
    }

    @discardableResult
    public func variant(_ variant: Variant) -> Self {
        switch variant {
        case .heading1:
            return applyHeading1Style()
        case .heading2:
            return applyHeading2Style()
        case .heading3:
            return applyHeading3Style()
        case .heading4:
            return applyHeading4Style()
        case .heading5:
            return applyHeading5Style()
        case .heading6:
            return applyHeading6Style()
        case .body:
            return applyBodyStyle()
        case .bodySmall:
            return applyBodySmallStyle()
        case .caption:
            return applyCaptionStyle()
        case .highlight:
            return applyHighlightStyle()
        }
    }

    private func applyHeading1Style() -> Self {
        return self
            .font(.h1)
            .textColor(.textPrimary)
    }

    private func applyHeading2Style() -> Self {
        return self
            .font(.h2)
            .textColor(.textPrimary)
    }

    private func applyHeading3Style() -> Self {
        return self
            .font(.h3)
            .textColor(.textPrimary)
            .numberOfLines(2)
    }

    private func applyHeading4Style() -> Self {
        return self
            .font(.h4)
            .textColor(.textPrimary)
            .numberOfLines(2)
    }

    private func applyHeading5Style() -> Self {
        return self
            .font(.h5)
            .textColor(.textPrimary)
            .numberOfLines(2)
    }

    private func applyHeading6Style() -> Self {
        return self
            .font(.h5)
            .textColor(.textPrimary)
            .numberOfLines(3)
    }

    private func applyBodyStyle() -> Self {
        return self
            .font(.text16)
            .textColor(.textPrimary)
            .numberOfLines(0)
    }

    private func applyBodySmallStyle() -> Self {
        return self
            .font(.text14)
            .textColor(.textPrimary)
            .numberOfLines(0)
    }

    private func applyCaptionStyle() -> Self {
        return self
            .font(.text13)
            .textColor(.textTertiary)
            .numberOfLines(0)
    }

    private func applyHighlightStyle() -> Self {
        return self
            .font(.textHighlight20)
            .textColor(.accentPrimary)
            .numberOfLines(0)
    }
}
