//
//  AlertBuilder.swift
//  Example
//
//  Created by Insider on 26.11.2025.
//

import UIKit

@MainActor public protocol AlertComponent {
    func build(into alert: UIAlertController)
}

@MainActor public struct AlertTitle: AlertComponent {

    public let text: String

    public func build(into alert: UIAlertController) {
        // Title is set during initialization
    }
}

@MainActor public struct AlertMessage: AlertComponent {

    public let text: String

    public func build(into alert: UIAlertController) {
        // Message is set during initialization
    }
}

@MainActor public struct AlertAction: AlertComponent {

    public let title: String
    public let style: UIAlertAction.Style
    private let handler: (() -> Void)?

    public init(title: String, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }

    public func build(into alert: UIAlertController) {
        let action = UIAlertAction(title: title, style: style) { _ in
            handler?()
        }
        alert.addAction(action)
    }
}

@resultBuilder public struct AlertBuilder {

    public static func buildBlock(_ components: AlertComponent...) -> [AlertComponent] {
        components
    }

    public static func buildOptional(_ component: [AlertComponent]?) -> [AlertComponent] {
        component ?? []
    }

    public static func buildEither(first component: [AlertComponent]) -> [AlertComponent] {
        component
    }

    public static func buildEither(second component: [AlertComponent]) -> [AlertComponent] {
        component
    }

    public static func buildArray(_ components: [[AlertComponent]]) -> [AlertComponent] {
        components.flatMap { $0 }
    }
}

@MainActor public struct Alert {

    public let title: String?
    public let message: String?
    private let components: [AlertComponent]

    public init(
        title: String? = nil,
        message: String? = nil,
        @AlertBuilder components: () -> [AlertComponent]
    ) {
        self.title = title
        self.message = message
        self.components = components()
    }

    public func show(on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        components.forEach { component in
            component.build(into: alert)
        }
        viewController.present(alert, animated: true)
    }

    public static func alert(
        title: String? = nil,
        message: String? = nil,
        @AlertBuilder components: () -> [AlertComponent]
     ) -> Self {
         return Self(title: title, message: message, components: components)
     }
 }
