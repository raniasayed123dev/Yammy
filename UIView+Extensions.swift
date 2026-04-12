//
//  UIView+Extensions.swift
//  Yammy
//
//  Created by rania on 13/02/2026.
//

import Foundation
import UIKit

extension UIView {
    
    func makeCircular(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
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
