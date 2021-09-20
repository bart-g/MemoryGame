//
//  AppDelegate.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setUpRootViewController()
        
        return true
    }
    
    private func setUpRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LobbyViewControllerAssembler().assemble()
        window?.makeKeyAndVisible()
    }
}

