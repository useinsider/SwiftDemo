//
//  ViewStyleBuilder.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public class ViewStyleBuilder<View: UIView> {

    public enum Variant {
        case surface
        case canvas
        case card
    }

    public weak var view: View?

    public init(view: View) {
        self.view = view
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Self {
        view?.backgroundColor = color
        return self
    }

    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> Self {
        view?.layer.cornerRadius = radius
        view?.layer.masksToBounds = true
        return self
    }

    @discardableResult
    public func borderColor(_ color: UIColor, width: CGFloat = 0.75) -> Self {
        view?.layer.borderColor = color.cgColor
        view?.layer.borderWidth = width
        return self
    }

    @discardableResult
    public func alpha(_ alpha: CGFloat) -> Self {
        view?.alpha = alpha
        return self
    }

    @discardableResult
    public func variant(_ variant: Variant) -> Self {
        switch variant {
        case .surface:
            return applySurfaceStyle()
        case .canvas:
            return applyCanvasStyle()
        case .card:
            return applyCardStyle()
        }
    }

    private func applySurfaceStyle() -> Self {
        return self
            .backgroundColor(.surfacePrimary)
    }

    private func applyCanvasStyle() -> Self {
        return self
            .backgroundColor(.backgroundCanvas)
    }

    private func applyCardStyle() -> Self {
        return self
            .backgroundColor(.surfacePrimary)
            .cornerRadius(12.0)
            .borderColor(.borderSubtle, width: 0.75)
    }
}
