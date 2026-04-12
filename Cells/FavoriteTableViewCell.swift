//
//  FavoriteTableViewCell.swift
//  Yammy
//
//  Created by rania on 20/02/2026.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    
    var onFavoriteClick: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        mealImage.makeCircular()
        self.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func favoriteToggleButton(_ sender: Any) {
        onFavoriteClick?()
    }
    
}
