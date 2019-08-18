//
//  AuthenticationViewController.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    private var authenticationService: AuthenticationService = AppDelegate.shared.authenticationService
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func signInButtonAction(_ sender: UIButton) {
        authenticationService.wakeUpSession()
    }
}
