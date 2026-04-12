import Foundation

class MenuViewModel {
    private(set) var filteredMeals: [Meal] = []
    var onDataUpdated: (() -> Void)?
    
    private let allMenus = [
        Menu(title: "Burgers", meals: [
            Meal(id: "100", name: "Cheese Burger", imageName: "burger3", basePrice: 30),
            Meal(id: "101", name: "Chicken Burger", imageName: "chickenBurger", basePrice: 35)
        ]),
        Menu(title: "Pizzas", meals: [
            Meal(id: "200", name: "Margherita", imageName: "pizza", basePrice: 60),
            Meal(id: "201", name: "Pepperoni", imageName: "Pepperoni", basePrice: 70)
        ]),
        Menu(title: "Drinks", meals: [
            Meal(id: "400", name: "Soda", imageName: "soda", basePrice: 6),
            Meal(id: "401", name: "Juice", imageName: "juice", basePrice: 10)
        ]),
        Menu(title: "Fries", meals: [
            Meal(id: "300", name: "Fries", imageName: "fries", basePrice: 10.5)
        ])
    ]
    
    func fetchMeals(for categoryName: String) {
        if let selectedMenu = allMenus.first(where: { $0.title == categoryName }) {
            self.filteredMeals = selectedMenu.meals
        } else {
            self.filteredMeals = []
        }
    }

    func numberOfMeals() -> Int {
        return filteredMeals.count
    }

    func meal(at index: Int) -> Meal {
        return filteredMeals[index]
    }

    func priceText(for meal: Meal) -> String {
        return "\(meal.price) EGP"
    }
}
