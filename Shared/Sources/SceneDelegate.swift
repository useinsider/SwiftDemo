//
//  SceneDelegate.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile
import UIKit

public final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    public var window: UIWindow?

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        for urlContext in connectionOptions.urlContexts {
            Insider.handle(urlContext.url)
        }
    }
}
