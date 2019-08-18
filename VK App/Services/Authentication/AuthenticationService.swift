//
//  AuthenticationService.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Foundation
import VK_ios_sdk

protocol AuthenticationServiceDelegate: class {
    func authenticationServiceShouldShow(_ viewController: UIViewController)
    func authenticationServiceSingIn()
    func authenticationServiceSighInFailed()
}

final class AuthenticationService: NSObject {
    private let appId: String = "YOUR_APP_ID"
    private let vkSDK: VKSdk
    
    weak var delegate: AuthenticationServiceDelegate?
    
    override init() {
        vkSDK = VKSdk.initialize(withAppId: appId)
        super.init()
        
        vkSDK.register(self)
        vkSDK.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope: [String] = ["offline,wall,friends"]
        
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            if state == .authorized {
                print("authorized")
                delegate?.authenticationServiceSingIn()
            } else if state == .initialized {
                VKSdk.authorize(scope)
            } else {
                print("Auth problem, state: \(state), error: \(error?.localizedDescription ?? "")")
                delegate?.authenticationServiceSighInFailed()
            }
        }
    }
}

extension AuthenticationService: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authenticationServiceSingIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
}

extension AuthenticationService: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authenticationServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
