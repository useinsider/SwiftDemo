//
//  AppSmartRecommenderAction.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import UIKit

public struct AppSmartRecommenderAction: Action {

    public let title: String = "App Smart Recommender"

    public func execute() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let rootViewController = keyWindow?.rootViewController as? UINavigationController else { return }

        let appSmartRecommenderViewController = AppSmartRecommenderViewController()
        rootViewController.pushViewController(appSmartRecommenderViewController, animated: true)
    }
}
