//
//  HomeViewController.swift
//  Yammy
//
//  Created by rania on 19/12/2025.
//

import UIKit

class HomeViewController: UIViewController {
    
 private let viewModel = HomeViewModel()
    var allMeals: [Meal] = []
    var filteredMeals: [Meal] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var pupularMeals: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var mealsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImageView.image = UIImage(named: "background1")
        categoryLabel.makeRounded(radius: 10)
        pupularMeals.makeRounded(radius: 10)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
         bindViewModel()
        
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.collectionViewLayout.invalidateLayout()
        filteredMeals = viewModel.getAllCurrentMeals()
        mealsCollectionView.reloadData()
        setupSearchController()
    }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mealsCollectionView.reloadData()
    }
    
   
  private func bindViewModel() {
      viewModel.onDataUpdated = { [weak self] in
          guard let self = self else { return }
          self.categoriesCollectionView.reloadData()
          
          self.filteredMeals = self.viewModel.getAllCurrentMeals()
          self.mealsCollectionView.reloadData()
          
      }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a meal..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
}
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoriesCollectionView {
            return viewModel.numberOfCategories()
        }
        return filteredMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            let category = viewModel.category(at: indexPath.row)
            cell.configure(with: category)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath) as! MealCollectionViewCell
            let meal = filteredMeals[indexPath.row]
           let priceText = viewModel.priceText(for: meal)
            let isFav = DataManager.shared.isFavorite(meal: meal)
            
            cell.configure(with: meal, priceText:priceText, isFavorite: isFav)
            
            cell.onFavoriteClick = { [weak self] in
                guard let self = self else { return }
                
                let meal = self.viewModel.meal(at: indexPath.row)
                    DataManager.shared.toggleFavorite(meal: meal)
                collectionView.reloadItems(at: [indexPath])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView{
            let item =  viewModel.category(at: indexPath.row)
            openMenuScreen(category: item)
        }
        else{
            let meal = viewModel.meal(at: indexPath.row)
                    openMealDetailsScreen(meal: meal)
        }
    }
    private func  openMenuScreen(category : Category){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC =  storyboard.instantiateViewController(withIdentifier: "MenuViewController" ) as! MenuViewController
        menuVC.menuItems = category.name
        navigationController?.pushViewController(menuVC, animated: true)
    }
    private func  openMealDetailsScreen(meal:Meal){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MealDetailsViewController") as? MealDetailsViewController {
            detailsVC.selectedMeal = meal
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            filteredMeals = viewModel.getAllCurrentMeals()
        } else {
            let allMeals = DataManager.shared.getAllMealsForSearch()
            filteredMeals = allMeals.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }}
        self.mealsCollectionView.reloadData()
    }
}
