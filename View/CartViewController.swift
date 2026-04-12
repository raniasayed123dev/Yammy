import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var SummaryView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        cartTableView.dataSource = self
        cartTableView.delegate = self
        SummaryView.makeRounded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTableView.reloadData()
        self.updateCartUI()
        cartTableView.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !DataManager.shared.cartMeals.isEmpty {
            animateTable()
        }
    }

    func updateCartUI() {
        let cartItems = DataManager.shared.cartMeals
        let isEmpty = cartItems.isEmpty
        
        toggleEmptyState(isEmpty: isEmpty)
        
        if !isEmpty {
            let totals = calculateTotals()
            updateLabels(subtotal: totals.subtotal, delivery: totals.delivery, total: totals.total)
        } else {
            emptyStateLabel.text = "Your Cart is empty, Order now 😋"
        }
    }

    func calculateTotals() -> (subtotal: Double, delivery: Double, total: Double) {
        let cartItems = DataManager.shared.cartMeals
        let subtotal = cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let deliveryFee = cartItems.isEmpty ? 0 : 20.0
        return (subtotal, deliveryFee, subtotal + deliveryFee)
    }
    
    func toggleEmptyState(isEmpty: Bool) {
        cartTableView.isHidden = isEmpty
        SummaryView.isHidden = isEmpty
        emptyStateStackView.isHidden = !isEmpty
    }
    
    func updateLabels(subtotal: Double, delivery: Double, total: Double) {
        subtotalLabel.text = "\(subtotal) EGP"
        deliveryLabel.text = "\(delivery) EGP"
        grandTotalLabel.text = "\(total) EGP"
        checkoutButton.setTitle("Proceed to Checkout (\(total) EGP)", for: .normal)
    }

    @IBAction func checkoutTapped(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "Confirm Order", message: "Are you sure you want to place this order?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Place Order", style: .default) { _ in
            self.showSuccessAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        confirmAlert.addAction(yesAction)
        confirmAlert.addAction(cancelAction)
        present(confirmAlert, animated: true)
    }

    func showSuccessAlert() {
        let successAlert = UIAlertController(title: "Success!", message: "Order placed successfully! 👨‍🍳", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Great!", style: .default) { _ in
            self.clearCartAndRefresh()
        }
        successAlert.addAction(okAction)
        present(successAlert, animated: true)
    }
    
    func clearCartAndRefresh() {
        DataManager.shared.cartMeals.removeAll()
        cartTableView.reloadData()
        updateCartUI()
    }
    
    func animateTable() {
        cartTableView.reloadData()
        cartTableView.layoutIfNeeded()
        cartTableView.alpha = 1
        let cells = cartTableView.visibleCells
        let tableViewHeight = cartTableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            cell.alpha = 0
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }, completion: nil)
            delayCounter += 1
        }
    }
}

extension CartViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.cartMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        let meal = DataManager.shared.cartMeals[indexPath.row]
        cell.mealNameLabel.text = meal.name
        let totalPrice = meal.price * Double(meal.quantity)
        cell.mealPriceLabel.text = "\(totalPrice) EGP"
        cell.mealImage.image = UIImage(named: meal.imageName)
        let sizes = ["Small", "Medium", "Large","XLarge"]
        if let index = sizes.firstIndex(of: meal.selectedSize) {
            cell.sizeSegmentedControl.selectedSegmentIndex = index
        }
        cell.quantityLabel.text = "\(meal.quantity)"
        cell.quantityStepper.value = Double(meal.quantity)
        cell.onQuantityChange = { newQuantity in
            DataManager.shared.cartMeals[indexPath.row].quantity = newQuantity
            tableView.reloadRows(at: [indexPath], with: .none)
            self.updateCartUI()
        }
        cell.onSizeChange = { newSize in
            let currentIndex = indexPath.row
            var currentMeal = DataManager.shared.cartMeals[currentIndex]
            currentMeal.selectedSize = newSize
            
            if let duplicateIndex = DataManager.shared.cartMeals.firstIndex(where: {
                $0.id == currentMeal.id && $0.selectedSize == newSize && $0 != currentMeal
            }) {
                DataManager.shared.cartMeals[duplicateIndex].quantity += currentMeal.quantity
                DataManager.shared.cartMeals.remove(at: currentIndex)
                tableView.reloadData()
                self.updateCartUI()
            } else {
                DataManager.shared.cartMeals[indexPath.row].selectedSize = newSize
                tableView.reloadRows(at: [indexPath], with: .none)
                self.updateCartUI()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.cartMeals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateCartUI()
        }
    }
}
