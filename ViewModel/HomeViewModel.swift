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
        meals = [Meal(name: "Burger", imageName: "burger3", price: 40),Meal(name: "Pizza", imageName: "pizza", price: 80.5),Meal(name: "Fries", imageName: "fries", price: 20.5) , Meal(name: "Soda", imageName: "soda", price: 10)]
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
}
