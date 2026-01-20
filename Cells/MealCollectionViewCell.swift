//
//  MealCollectionViewCell.swift
//  Yammy
//
//  Created by rania on 20/12/2025.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
 
   @IBOutlet weak var mealImageView : UIImageView!
   @IBOutlet weak var mealNameLabel : UILabel!
    @IBOutlet weak var mealPriceLabel : UILabel!
    
    func configure( with meal : Meal , priceText : String){
        mealImageView.image = UIImage(named: meal.imageName)
        mealNameLabel.text = meal.name
        mealPriceLabel.text = priceText
    }
}
