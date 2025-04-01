//
//  SceneDelegate.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import UIKit

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let service = ConnectionsService()

        service.fetchConnections { result in
            Task { @MainActor in
                let viewModel: RouteViewModel

                switch result {
                case .success(let connections):
                    let finder = RouteFinder(connections: connections)
                    viewModel = RouteViewModel(routeFinder: finder, connectionsService: service)

                case .failure(let error):
                    let fallback = RouteFinder(connections: [])
                    viewModel = RouteViewModel(routeFinder: fallback, connectionsService: service)
                    viewModel.setInitialError(error.localizedDescription)
                }

                let mainVC = MainViewController(viewModel: viewModel)

                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = mainVC
                self.window = window
                window.makeKeyAndVisible()
            }
        }
    }
}


