//
//  UIViewController + Storyboard.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

extension UIViewController {
    class func loadFrom<T: UIViewController>(storyboard: String) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Error: Initial view conntroller has nil value")
        }
        
        return viewController
    }
}
