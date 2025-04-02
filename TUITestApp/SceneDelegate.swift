//
//  SceneDelegate.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let service = ConnectionsService()
        let viewModel = RouteViewModel(connectionsService: service)
        let mainVC = MainViewController(viewModel: viewModel)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = mainVC
        self.window = window
        window.makeKeyAndVisible()
    }
}


