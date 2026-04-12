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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func favoriteTapped(_ sender: Any) {
        onFavoriteClick?()
    }
    func configure( with meal : Meal , priceText : String , isFavorite: Bool){
        mealImageView.image = UIImage(named: meal.imageName)
        mealImageView.makeRounded(radius: 50)
        mealNameLabel.text = meal.name
        mealNameLabel.makeRounded(radius: 10)
        mealPriceLabel.text = priceText
        mealPriceLabel.makeRounded(radius: 10)
        self.addShadow()
        let heartImage = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: heartImage), for: .normal)
    }
    var onFavoriteClick: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
