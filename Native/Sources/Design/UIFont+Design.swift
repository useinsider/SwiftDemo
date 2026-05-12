//
//  UIFont+Design.swift
//  Example
//
//  Created by Insider on 21.12.2025.
//

import UIKit

@MainActor @frozen public struct Font {

    public var name: Name {
        return .figtree
    }

    public let size: CGFloat
    public let emphasis: Emphasis

    @frozen public enum Name: String {
        case figtree = "Figtree"
        case redhatdisplay = "RedHatDisplay"
    }

    @frozen public enum Emphasis: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case extraBold = "ExtraBold"
        case extraBoldItalic = "ExtraBoldItalic"
        case italic = "Italic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case regular = "Regular"
        case semiBold = "SemiBold"
        case semiBoldItalic = "SemiBoldItalic"

        public func bold() -> Self {
            switch self {
            case .black, .regular, .medium, .semiBold, .bold:
                return .bold
            case .light:
                return .regular
            case .blackItalic, .italic, .mediumItalic, .semiBoldItalic, .boldItalic:
                return .boldItalic
            case .lightItalic:
                return .italic
            case .extraBold:
                return .extraBold
            case .extraBoldItalic:
                return .extraBoldItalic
            }
        }

        public func italic() -> Self {
            switch self {
            case .black, .blackItalic:
                return .blackItalic
            case .regular, .italic:
                return .italic
            case .medium, .mediumItalic:
                return .mediumItalic
            case .semiBold, .semiBoldItalic:
                return .semiBoldItalic
            case .extraBold, .extraBoldItalic:
                return .extraBoldItalic
            case .bold, .boldItalic:
                return .boldItalic
            case .light, .lightItalic:
                return .lightItalic
            }
        }
    }

    public func bold() -> Self {
        return Self(size: size, emphasis: emphasis.bold())
    }

    public func italic() -> Self {
        return Self(size: size, emphasis: emphasis.italic())
    }
}

extension Font {

    public static let h1 = Self(size: 24, emphasis: .bold)
    public static let h2 = Self(size: 20, emphasis: .bold)
    public static let h3 = Self(size: 18, emphasis: .bold)
    public static let h4 = Self(size: 16, emphasis: .bold)
    public static let h5 = Self(size: 14, emphasis: .bold)
    public static let h6 = Self(size: 13, emphasis: .bold)

    public static func buttonLarge(emphasis: Emphasis) -> Self {
        return Self(size: 15, emphasis: emphasis)
    }

    public static func buttonSmall(emphasis: Emphasis) -> Self {
        return Self(size: 12, emphasis: emphasis)
    }

    public static let text18 = Self(size: 18, emphasis: .regular)
    public static let text16 = Self(size: 16, emphasis: .regular)
    public static let text14 = Self(size: 14, emphasis: .regular)
    public static let text13 = Self(size: 13, emphasis: .regular)

    public static let textHighlight24 = Self(size: 24, emphasis: .bold)
    public static let textHighlight20 = Self(size: 20, emphasis: .bold)
}

extension UIFont {

    @MainActor public static func font(_ font: Font) -> UIFont {
        let name = "\(font.name)-\(font.emphasis)"
        let descriptor = UIFontDescriptor(name: name, size: font.size)
        return UIFont(descriptor: descriptor, size: font.size)
    }

    @MainActor public static func scaledFont(
        _ font: Font,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        return UIFontMetrics.default
            .scaledFont(for: self.font(font), compatibleWith: traitCollection)
    }

    @MainActor public static func scaledFont(
        _ font: Font,
        textStyle: UIFont.TextStyle,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        return UIFontMetrics(forTextStyle: textStyle)
            .scaledFont(for: self.font(font), compatibleWith: traitCollection)
    }
}
