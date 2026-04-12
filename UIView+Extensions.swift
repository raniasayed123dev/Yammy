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
        if let imageView = self as? UIImageView {
            imageView.layer.masksToBounds = true
        }
    }
    
    func forceCircleMask() {
        self.layoutIfNeeded()
        let side = min(self.bounds.width, self.bounds.height)
        let rect = CGRect(x: (self.bounds.width - side) / 2,
                          y: (self.bounds.height - side) / 2,
                          width: side,
                          height: side)
        let circlePath = UIBezierPath(ovalIn: rect)
        let maskLayer = CAShapeLayer()
        maskLayer.path = circlePath.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
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
