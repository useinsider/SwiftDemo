//
//  AppFramesAction.swift
//  Example
//
//  Created by Heysem on 20.06.2026.
//

import UIKit

public struct AppFramesAction: Action {

    public let title: String = "App Frames"

    public func execute() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let navigationController = keyWindow?.rootViewController as? UINavigationController else { return }

        navigationController.pushViewController(AppFramesViewController(), animated: true)
    }
}
