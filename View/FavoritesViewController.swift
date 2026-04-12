import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateStackView: UIStackView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var favoriteHeartImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        favoriteHeartImage.layer.transform = perspective
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataManager.shared.favoriteMeals.isEmpty {
            animateHeart()
        }
    }
    
    func updateFavoritesUI() {
        let isEmpty = DataManager.shared.favoriteMeals.isEmpty
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = isEmpty ? 0 : 1
            self.emptyStateStackView.alpha = isEmpty ? 1 : 0
            self.tableView.isHidden = isEmpty
            self.emptyStateStackView.isHidden = !isEmpty
        }
        
        if isEmpty {
            animateHeart()
        } else {
            tableView.reloadData()
        }
    }
    
    func animateHeart() {
        if favoriteHeartImage.layer.animation(forKey: "rotate3D") == nil {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            rotateAnimation.fromValue = 0
            rotateAnimation.toValue = CGFloat.pi * 2.0
            rotateAnimation.duration = 3.0
            rotateAnimation.repeatCount = .infinity
            rotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            favoriteHeartImage.layer.add(rotateAnimation, forKey: "rotate3D")
        }
    }
}

extension FavoritesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.favoriteMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
        let meal = DataManager.shared.favoriteMeals[indexPath.row]
        cell.mealName.text = meal.name
        cell.mealImage.image = UIImage(named: meal.imageName)
        cell.mealPrice.text = "\(meal.price) LE"
        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        cell.onFavoriteClick = { [weak self] in
            DataManager.shared.toggleFavorite(meal: meal)
            self?.updateFavoritesUI()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = DataManager.shared.favoriteMeals[indexPath.row]
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "MealDetailsViewController") as? MealDetailsViewController {
            detailsVC.selectedMeal = selectedMeal
            navigationController?.pushViewController(detailsVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
