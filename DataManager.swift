import Foundation

class DataManager {
    static let shared = DataManager()
    private let favoritesKey = "user_favorites_key"
    private let cartKey = "user_cart_key"
    var favoriteMealNames: Set<String> = []
    
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
    
    func clearAllData() {
        favoriteMeals.removeAll()
        cartMeals.removeAll()
        UserDefaults.standard.removeObject(forKey: favoritesKey)
        UserDefaults.standard.removeObject(forKey: cartKey)
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
