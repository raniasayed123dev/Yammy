//
//  HomeViewModel.swift
//  Yammy
//
//  Created by rania on 19/12/2025.
//

import Foundation
class HomeViewModel {
    
    private(set) var categories: [Category] = []
    private(set) var meals : [Meal] = []
    
    var onDataUpdated: (() -> Void)?
    
    init () {
        loadCategories()
        loadMeals()
    }
    
    
    private func loadCategories() {
        categories = [Category( name: "Burgers", imageName: "burger3"),Category( name: "Fries", imageName: "fries"),Category( name: "Pizzas", imageName: "pizza"),Category( name: "Drinks" , imageName: "soda")]
        onDataUpdated?()
    }
    
    func numberOfCategories() -> Int {
        categories.count
    }
    func category(at index : Int)-> Category{
        categories[index]
    }
    private func loadMeals() {
        meals = [Meal(id: "100", name: "Cheese Burger", imageName: "burger3", basePrice: 40),Meal(id: "200", name: "Margherita", imageName: "pizza",basePrice: 80.5),Meal(id: "300", name: "Fries", imageName: "fries", basePrice: 20.5) , Meal(id: "400", name: "Soda", imageName: "soda", basePrice: 10)]
    }
    func priceText( for meal : Meal ) -> String{
       "\(meal.price) EGP"
    }
    func numberOfMeals() -> Int {
        meals.count
    }
    func meal(at index: Int) -> Meal {
      meals[index]
    }
    func getAllCurrentMeals() -> [Meal] {
        return meals
    }
}
