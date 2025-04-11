//
//  SceneDelegate.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let service = ConnectionsService()
        let viewModel = RouteViewModel(connectionsService: service)
        let contentView = MainView(viewModel: viewModel)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
}


