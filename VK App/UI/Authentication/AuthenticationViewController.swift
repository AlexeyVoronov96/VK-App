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
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6)
        button.setTitleColor(#colorLiteral(red: 0.3725763559, green: 0.679697752, blue: 0.9031428695, alpha: 1), for: .normal)
        button.setTitle("Войти в ВК", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        view.addSubview(signInButton)
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func signInButtonAction(_ sender: UIButton) {
        authenticationService.wakeUpSession()
    }
}
