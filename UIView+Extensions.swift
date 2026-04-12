//
//  UIView+Extensions.swift
//  Yammy
//
//  Created by rania on 13/02/2026.
//

import Foundation
import UIKit

extension UIView {
    
    func makeCircular() {
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layoutIfNeeded()
        let size = min(self.bounds.width, self.bounds.height)
        self.layer.cornerRadius = size / 2
    }
    func makeRounded(radius: CGFloat = 15){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    func addShadow() {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.1
            self.layer.masksToBounds = false
        }
    
    
    }
