//
//  HomeViewController.swift
//  Yammy
//
//  Created by rania on 19/12/2025.
//

import UIKit

class HomeViewController: UIViewController  {
  
    
    
 private let viewModel = HomeViewModel()
    
   @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var mealsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImageView.image = UIImage(named: "background1")
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
         bindViewModel()
        
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.reloadData()
        mealsCollectionView.collectionViewLayout.invalidateLayout()
       
    }
  private func bindViewModel() {
      viewModel.onDataUpdated = { [weak self] in
          self?.categoriesCollectionView.reloadData()
      }
    }
}
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoriesCollectionView {
            return viewModel.numberOfCategories()
        }
       return viewModel.numberOfMeals()
    }
    //    func collectionView( _ colectionView : UICollectionView ,layout collectionLayout : UICollectionViewLayout , sizeForItemAt indexPath : IndexPath) -> CGSize {
    //        return CGSize(width:600, height:200)
    //    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            let category = viewModel.category(at: indexPath.row)
            cell.configure(with: category)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath) as! MealCollectionViewCell
            let meal = viewModel.meal(at: indexPath.row)
            let priceText = viewModel.priceText(for: meal)
            cell.configure(with: meal, priceText: priceText)
            return cell
        }
    }
    private func  openMenuScreen(){
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC =  storyboard.instantiateViewController(withIdentifier: "MenuViewController" ) as! MenuViewController
        navigationController?.pushViewController(menuVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView{
             openMenuScreen()
        }
    }
}


