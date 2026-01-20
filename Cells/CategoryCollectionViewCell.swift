//
//  CategoryCollectionViewCell.swift
//  Yammy
//
//  Created by rania on 20/12/2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
   @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
     func configure(with category: Category) {
         categoryImageView.image = UIImage(named: category.imageName)
         categoryNameLabel.text = category.name
    }
}
