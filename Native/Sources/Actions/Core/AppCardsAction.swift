//
//  AppCardsAction.swift
//  Example
//
//  Created by Insider on 26.03.2026.
//

import UIKit

public struct AppCardsAction: Action {

    public let title: String = "App Cards"

    public func execute() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let rootViewController = keyWindow?.rootViewController as? UINavigationController else { return }

        let appCardsViewController = AppCardsViewController()
        rootViewController.pushViewController(appCardsViewController, animated: true)
    }
}
