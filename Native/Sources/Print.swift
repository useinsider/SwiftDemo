//
//  Print.swift
//  Example
//
//  Created by Özgür Vatansever on 25.03.2026.
//

import UIKit

@MainActor public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    Swift.print(items, separator: separator, terminator: terminator)
    let keyWindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }

    guard let rootViewController = keyWindow?.rootViewController as? UINavigationController else { return }
    guard let viewController = rootViewController.viewControllers.first as? MainViewController else { return }

    let string = items.lazy.map { "\($0)" }.joined(separator: separator)
    viewController.printLabel.text = "\(string)\(terminator)"
}
