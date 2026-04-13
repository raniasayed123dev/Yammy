import Foundation

class MenuViewModel {
    private(set) var filteredMeals: [Meal] = []
    var onDataUpdated: (() -> Void)?
    
    
    private let allMenus = [
            Menu(title: "Sandwich", meals: [
                Meal(id: "100", name: "Cheese Burger", imageName: "burger3", basePrice: 30),
                Meal(id: "101", name: "Chicken Burger", imageName: "chickenBurger", basePrice: 35), Meal(id: "102", name: "Shawarma", imageName: "shawarma", basePrice: 30),Meal(id: "103", name: "Falafel", imageName: "falafel", basePrice: 10),Meal(id: "104", name: "Fries Sandwich", imageName: "frieswich", basePrice: 10)
            ]),
            Menu(title: "Pizzas", meals: [
                Meal(id: "200", name: "Margherita", imageName: "pizza", basePrice: 60),
                Meal(id: "201", name: "Pepperoni", imageName: "Pepperoni", basePrice: 70), Meal(id: "202", name: "chicken Ranch", imageName: "chickenRanch", basePrice: 85),Meal(id: "203", name: "chicken BBQ", imageName: "chickenBBQ", basePrice: 80),Meal(id: "204", name: "super Supreme", imageName: "superSupreme", basePrice: 85)
            ]),
            Menu(title: "Drinks", meals: [
                Meal(id: "400", name: "Soda", imageName: "soda", basePrice: 6),Meal(id: "401", name: "Water", imageName: "water", basePrice: 7),
                Meal(id: "402", name: "Orange juice", imageName: "orange", basePrice: 10),Meal(id: "403", name: "Strawberry juice", imageName: "strawberry", basePrice: 12),Meal(id: "404", name: "Mango juice", imageName: "mango", basePrice: 10)
            ]),
            Menu(title: "Extras", meals: [
                Meal(id: "300", name: "Fries", imageName: "fries", basePrice: 10.5),Meal(id: "301", name: "Ketchup", imageName: "ketchup", basePrice: 8),Meal(id: "303", name: "Salad", imageName: "salad", basePrice: 10),Meal(id: "304", name: "Chili", imageName: "chili", basePrice: 5)
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
