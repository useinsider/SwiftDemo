//
//  ButtonStyleBuilder.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public final class ButtonStyleBuilder: ViewStyleBuilder<DynamicFontAwareButton> {

    public enum Variant {
        case primary
        case secondary
        case tertiary
        case destructive
        case ghost
    }

    public enum Size {
        case large
        case small
    }

    private var font: Font?
    private var backgroundColor: UIColor?
    private var contentInsets: NSDirectionalEdgeInsets?
    private var cornerRadius: CGFloat?
    private var backgroundImages: [UInt: UIImage] = [:]

    @discardableResult
    public override func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }

    @discardableResult public func font(_ font: Font) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    public func title(_ text: String, for state: UIControl.State = .normal) -> Self {
        view?.setTitle(text, for: state)
        return self
    }

    @discardableResult
    public func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        view?.setTitleColor(color, for: state)
        return self
    }

    @discardableResult
    public func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        self.contentInsets = contentInsets
        return self
    }

    @discardableResult
    public func backgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        if let image {
            backgroundImages[state.rawValue] = image
        } else {
            backgroundImages.removeValue(forKey: state.rawValue)
        }
        return self
    }

    @discardableResult public func build() -> Self {
        var configuration = UIButton.Configuration.filled()
        if let cornerRadius {
            configuration.background.cornerRadius = cornerRadius
        }
        if let backgroundColor {
            configuration.baseBackgroundColor = backgroundColor
        }
        if let contentInsets {
            configuration.contentInsets = contentInsets
        }
        configuration.background.image = backgroundImages[UIControl.State.normal.rawValue]
        view?.configuration = configuration
        if let font {
            view?.setFont(font)
        }
        view?.configurationUpdateHandler = { button in
            var configuration = button.configuration
            configuration?.background.image = self.backgroundImages[button.state.rawValue]
            button.configuration = configuration
        }
        return self
    }

    @discardableResult
    public func variant(_ variant: Variant, size: Size = .large) -> Self {
        switch variant {
        case .primary:
            return applyPrimaryStyle(size: size)
        case .secondary:
            return applySecondaryStyle(size: size)
        case .tertiary:
            return applyTertiaryStyle(size: size)
        case .destructive:
            return applyDestructiveStyle(size: size)
        case .ghost:
            return applyGhostStyle(size: size)
        }
    }

    private func applyPrimaryStyle(size: Size) -> Self {
        return self
            .font(size == .large ? .buttonLarge(emphasis: .bold) : .buttonSmall(emphasis: .bold))
            .backgroundImage(.buttonBackground, for: .normal)
            .backgroundImage(.buttonBackgroundHighlighted, for: .highlighted)
            .titleColor(.onAccentPrimary, for: .normal)
            .titleColor(.onAccentPrimary, for: .highlighted)
            .cornerRadius(5.0)
            .contentInsets(NSDirectionalEdgeInsets(inset: 10.0))
            .build()
    }

    private func applySecondaryStyle(size: Size) -> Self {
        return self
            .font(size == .large ? .buttonLarge(emphasis: .semiBold) : .buttonSmall(emphasis: .semiBold))
            .backgroundImage(.buttonBackground, for: .normal)
            .backgroundImage(.buttonBackgroundHighlighted, for: .highlighted)
            .titleColor(.onAccentPrimary, for: .normal)
            .titleColor(.onAccentPrimary, for: .highlighted)
            .cornerRadius(5.0)
            .contentInsets(NSDirectionalEdgeInsets(inset: 10.0))
            .build()
    }

    private func applyTertiaryStyle(size: Size) -> Self {
        return self
            .font(size == .large ? .buttonLarge(emphasis: .medium) : .buttonSmall(emphasis: .medium))
            .backgroundImage(.buttonBackground, for: .normal)
            .backgroundImage(.buttonBackgroundHighlighted, for: .highlighted)
            .titleColor(.onAccentPrimary, for: .normal)
            .titleColor(.onAccentPrimary, for: .highlighted)
            .cornerRadius(5.0)
            .contentInsets(NSDirectionalEdgeInsets(inset: 10.0))
            .build()
    }

    private func applyDestructiveStyle(size: Size) -> Self {
        return self
            .font(size == .large ? .buttonLarge(emphasis: .semiBold) : .buttonSmall(emphasis: .semiBold))
            .titleColor(.statusDanger, for: .normal)
            .titleColor(.statusDanger, for: .highlighted)
            .cornerRadius(5.0)
            .contentInsets(NSDirectionalEdgeInsets(inset: 10.0))
            .build()
    }

    private func applyGhostStyle(size: Size) -> Self {
        return self
            .font(size == .large ? .buttonLarge(emphasis: .semiBold) : .buttonSmall(emphasis: .semiBold))
            .backgroundColor(.backgroundPrimary)
            .titleColor(.onAccentPrimary, for: .normal)
            .titleColor(.onAccentPrimary, for: .highlighted)
            .borderColor(.borderSubtle, width: 0.75)
            .cornerRadius(5.0)
            .contentInsets(NSDirectionalEdgeInsets(inset: 10.0))
            .build()
    }
}
