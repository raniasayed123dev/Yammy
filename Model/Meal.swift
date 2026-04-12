//
//  Meal.swift
//  Yammy
//
//  Created by rania on 19/12/2025.
//

import Foundation
struct Meal: Codable ,Equatable {
    let id : String
    let name : String
    let imageName : String
    let basePrice : Double
    var quantity: Int = 1
    var selectedSize: String = "Small"
    var price: Double {
        switch selectedSize {
        case "Medium":
            return basePrice + 10
        case "Large":
            return  basePrice + 20
        case "XLarge":
            return  basePrice + 30
        default:
            return basePrice
        }}
    
}
