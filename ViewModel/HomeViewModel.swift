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
        categories = [
            Category(name: "Sandwich", imageName: "shawarma"),
            Category(name: "Pizzas", imageName: "pizza"),
            Category(name: "Drinks", imageName: "soda"),
            Category(name: "Extras", imageName: "ketchup")
        ]
        onDataUpdated?()
    }
    
    func numberOfCategories() -> Int {
        categories.count
    }

    func category(at index: Int) -> Category {
        categories[index]
    }

    private func loadMeals() {
        meals = [
            Meal(id: "100", name: "Cheese Burger", imageName: "burger3", basePrice: 30),
            Meal(id: "200", name: "Margherita", imageName: "pizza", basePrice: 60),
            Meal(id: "300", name: "Fries", imageName: "fries", basePrice: 10.5),
            Meal(id: "401", name: "Water", imageName: "water", basePrice: 7)
        ]
    }

    func priceText(for meal: Meal) -> String {
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
