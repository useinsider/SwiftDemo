//
//  TextViewStyleBuilder.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public final class TextViewStyleBuilder: ViewStyleBuilder<UITextView> {

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
}
