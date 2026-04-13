import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mealImageView : UIImageView!
    @IBOutlet weak var mealNameLabel : UILabel!
    @IBOutlet weak var mealPriceLabel : UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onFavoriteClick: (() -> Void)?

    @IBAction func favoriteTapped(_ sender: Any) {
        onFavoriteClick?()
    }

    func configure(with meal: Meal, priceText: String, isFavorite: Bool) {
        mealImageView.image = UIImage(named: meal.imageName)
        mealImageView.contentMode = .scaleAspectFit
        mealImageView.backgroundColor = .clear
        mealImageView.layer.mask = nil
        mealImageView.clipsToBounds = false
        
        mealNameLabel.text = meal.name
        mealNameLabel.makeRounded(radius: 10)
        mealPriceLabel.text = priceText
        mealPriceLabel.makeRounded(radius: 10)
        self.addShadow()
        let heartImage = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: heartImage), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let aspectConstraint = mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor)
        aspectConstraint.priority = UILayoutPriority(999)
        aspectConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Removed forceCircleMask to show full PNG
    }
}

