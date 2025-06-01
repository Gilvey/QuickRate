//
//  SceneDelegate.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 29.05.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let networkService = CurrencyExchangeNetworkService()
        let viewModel = CurrencyConverterViewModel(currencyExchangeService: networkService)
        let rootViewController = UINavigationController(
            rootViewController: CurrencyConverterViewController(
                viewModel: viewModel
            )
        )
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

