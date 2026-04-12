import UIKit

class menuTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onFavoriteClick: (() -> Void)?

    @IBAction func favoriteTapped(_ sender: Any) {
        onFavoriteClick?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let aspectConstraint = menuImage.heightAnchor.constraint(equalTo: menuImage.widthAnchor)
        aspectConstraint.priority = UILayoutPriority(999)
        aspectConstraint.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        menuImage.forceCircleMask()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with meal: Meal, priceText: String, isFavorite: Bool) {
        menuImage.image = UIImage(named: meal.imageName)
        nameLabel.text = meal.name
        nameLabel.makeRounded(radius: 10)
        priceLabel.text = priceText
        priceLabel.makeRounded(radius: 10)
        self.addShadow()
        let heartImage = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: heartImage), for: .normal)
    }
}
