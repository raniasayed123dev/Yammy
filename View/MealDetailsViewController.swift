//
//  MealDetailsViewController.swift
//  Yammy
//
//  Created by rania on 19/12/2025.
//

import UIKit

class MealDetailsViewController: UIViewController {
    var selectedMeal: Meal?
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
            self.additionalSafeAreaInsets = UIEdgeInsets(top: -view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
      
        if let meal = selectedMeal {
        let isFav = DataManager.shared.isFavorite(meal: meal)
        updateFavoriteButton(isFavorite: isFav)
        }
        if let mealData = selectedMeal {
                setupUI(with: mealData)
                let isFav = DataManager.shared.isFavorite(meal: mealData)
                updateFavoriteButton(isFavorite: isFav)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemRed
    }
    
    private func setupUI(with meal: Meal) {
        mealName.text = meal.name
        mealPrice.text = "\(meal.price) EGP"
        if let image = UIImage(named: meal.imageName) {
                mealImage.image = image
        } else {
            mealImage.image = UIImage(named: "burger3")
        }
        mealImage.layer.cornerRadius = 20
        mealImage.clipsToBounds = true
    }

    
    func updateFavoriteButton(isFavorite: Bool) {
    let imageName = isFavorite ? "heart.fill" : "heart"
    favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    @IBAction func favoriteTapped(_ sender: Any) {
        if let meal = selectedMeal {
            DataManager.shared.toggleFavorite(meal: meal)
            let isFav = DataManager.shared.isFavorite(meal: meal)
            updateFavoriteButton(isFavorite: isFav)
        }
    }
    @IBAction func quantityChanged(_ sender: UIStepper) {
        let currentQuantity = Int(sender.value)
            quantityLabel.text = "\(currentQuantity)"
        selectedMeal?.quantity = currentQuantity
        if let meal = selectedMeal {
                let totalPrice = meal.price * Double(meal.quantity)
                mealPrice.text = "\(totalPrice) EGP"
            }
    }
    
    @IBAction func sizeChanged(_ sender: UISegmentedControl) {
        let sizes = ["Small", "Medium", "Large","XLarge"]
        selectedMeal?.selectedSize = sizes[sender.selectedSegmentIndex]
        
        if let meal = selectedMeal {
            let totalPrice = meal.price * Double(meal.quantity)
            mealPrice.text = "\(totalPrice) EGP"
           
        }
    }
    @IBAction func addToCartTapped(_ sender: Any) {
        guard var meal = selectedMeal else { return }
        
        let sizes = ["Small", "Medium", "Large","XLarge"]
        let selectedSize = sizes[sizeSegmentedControl.selectedSegmentIndex]
        meal.quantity = Int(quantityLabel.text ?? "1") ?? 1
        
        let isAlreadyInCart = DataManager.shared.addToCart(meal: meal)
        
        if isAlreadyInCart {
               let _  = "تم تحديث الكمية في السلة بنجاح لـ \(meal.name)"
            } else {
               let _  = "تم إضافة \(meal.name) للسلة بنجاح"
            }
       
            meal.selectedSize = selectedSize
        
        let alert = UIAlertController(title: "Add to Cart", message:"if you want to add \(meal.name) press on the agree ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Agree", style:.default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        
        
        
    }
    
        
    
}
