import Foundation

class DataManager {
    static let shared = DataManager()
    private let favoritesKey = "user_favorites_key"
    private let cartKey = "user_cart_key"
    var favoriteMealNames: Set<String> = []
    
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
    
    var favoriteMeals: [Meal] = [] {
        didSet { saveFavoriteData() }
    }
    
    var cartMeals: [Meal] = [] {
        didSet { saveCartData() }
    }
    
    private init() {
        loadFavoriteData()
        loadCartData()
    }
    
    func toggleFavorite(meal: Meal) {
        if let index = favoriteMeals.firstIndex(where: { $0.id == meal.id }) {
            favoriteMeals.remove(at: index)
        } else {
            favoriteMeals.append(meal)
        }
    }

    func isFavorite(meal: Meal) -> Bool {
       return favoriteMeals.contains(where: { $0.id == meal.id })
    }
    
    func addToCart(meal: Meal) -> Bool {
        if let index = cartMeals.firstIndex(where: { $0.id == meal.id && $0.selectedSize == meal.selectedSize }) {
            cartMeals[index].quantity += meal.quantity
            return true
        } else {
            cartMeals.append(meal)
            return false
        }
    }
  
    func getAllMealsForSearch() -> [Meal] {
        return allMenus.flatMap { $0.meals }
    }

    private func saveFavoriteData() {
        if let encoded = try? JSONEncoder().encode(favoriteMeals) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }

    private func loadFavoriteData() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Meal].self, from: data) {
            favoriteMeals = decoded
        }
    }
    
    private func saveCartData() {
        if let encoded = try? JSONEncoder().encode(cartMeals) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }
    
    private func loadCartData() {
        if let data = UserDefaults.standard.data(forKey: cartKey),
           let decoded = try? JSONDecoder().decode([Meal].self, from: data) {
            cartMeals = decoded
        }
    }
}
