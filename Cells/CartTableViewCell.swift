import UIKit

class CartTableViewCell: UITableViewCell {
    var meal: Meal?
    var onSizeChange: ((String) -> Void)?
    
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealPriceLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    var onQuantityChange: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let aspectConstraint = mealImage.heightAnchor.constraint(equalTo: mealImage.widthAnchor)
        aspectConstraint.priority = UILayoutPriority(999)
        aspectConstraint.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mealImage.forceCircleMask()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func sizeChanged(_ sender: UISegmentedControl) {
        let sizes = ["Small", "Medium", "Large","XLarge"]
        let selectedSize = sizes[sender.selectedSegmentIndex]
        onSizeChange?(selectedSize)
    }

    @IBAction func quantityChanged(_ sender: UIStepper) {
        let currentQuantity = Int(sender.value)
        quantityLabel.text = "\(currentQuantity)"
        onQuantityChange?(currentQuantity)
    }
}
