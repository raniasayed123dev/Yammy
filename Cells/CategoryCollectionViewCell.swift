import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let aspectConstraint = categoryImageView.heightAnchor.constraint(equalTo: categoryImageView.widthAnchor)
        aspectConstraint.priority = UILayoutPriority(999)
        aspectConstraint.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        categoryImageView.forceCircleMask()
    }

    func configure(with category: Category) {
        categoryImageView.image = UIImage(named: category.imageName)
        categoryNameLabel.text = category.name
        categoryNameLabel.makeRounded(radius: 10)
    }
}
