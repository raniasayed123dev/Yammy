import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    
    var onFavoriteClick: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let aspectConstraint = mealImage.heightAnchor.constraint(equalTo: mealImage.widthAnchor)
        aspectConstraint.priority = UILayoutPriority(999)
        aspectConstraint.isActive = true
        self.addShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mealImage.forceCircleMask()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func favoriteToggleButton(_ sender: Any) {
        onFavoriteClick?()
    }
}
