//
//  AppDelegate.swift
//  VK App
//
//  Created by Алексей Воронов on 17.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var authenticationService: AuthenticationService!
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        authenticationService = AuthenticationService()
        authenticationService.delegate = self
        
        window?.rootViewController = AuthenticationViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        return true
    }
}

extension AppDelegate: AuthenticationServiceDelegate {
    func authenticationServiceShouldShow(_ viewController: UIViewController) {
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authenticationServiceSingIn() {
        window?.rootViewController = UINavigationController(rootViewController: FeedViewController())
    }
    
    func authenticationServiceSighInFailed() {
    }
}

