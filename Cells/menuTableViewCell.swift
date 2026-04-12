//
//  menuTableViewCell.swift
//  Yammy
//
//  Created by rania on 06/02/2026.
//

import UIKit

class menuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func favoriteTapped(_ sender: Any) {
        onFavoriteClick?()
    }
    
    func configure( with meal : Meal , priceText : String , isFavorite: Bool){
        menuImage.image = UIImage(named: meal.imageName)
        menuImage.makeCircular()
       nameLabel.text = meal.name
        nameLabel.makeRounded(radius: 10)
        priceLabel.text = priceText
        priceLabel.makeRounded(radius: 10)
        self.addShadow()
        let heartImage = isFavorite ? "heart.fill" : "heart"
                favoriteButton.setImage(UIImage(systemName: heartImage), for: .normal)
    }
    var onFavoriteClick: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
