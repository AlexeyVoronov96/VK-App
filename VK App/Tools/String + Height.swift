//
//  String + Height.swift
//  VK App
//
//  Created by Алексей Воронов on 19.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size =  self.boundingRect(with: textSize,
                                      options: .usesLineFragmentOrigin,
                                      attributes: [NSAttributedString.Key.font: font],
                                      context: nil)
        
        return ceil(size.height)
    }
}
