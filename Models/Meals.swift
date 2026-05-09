//
//  Meals.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
// Meal.swift
// Esse arquivo define como é uma refeição no nosso app.
// Cada vez que o usuário registrar uma refeição, um objeto
// desse tipo será criado e salvo.


import Foundation
import SwiftData

@Model
class Meals {
    var name: String
    var registeredAt: Date
    @Relationship(deleteRule: .cascade) var foodItems: [FoodItem] = []

    var totalCalories: Double {
        return foodItems.reduce(0) { $0 + $1.calories }
    }
    var totalProtein: Double {
        return foodItems.reduce(0) { $0 + $1.protein }
    }
    var totalCarbs: Double {
        return foodItems.reduce(0) { $0 + $1.carbs }
    }
    var totalFat: Double {
        return foodItems.reduce(0) { $0 + $1.fat }
    }
    var isFromToday: Bool {
        return Calendar.current.isDateInToday(registeredAt)
    }

    init(name: String) {
        self.name = name
        self.registeredAt = Date()
    }
}
