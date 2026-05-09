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
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var registeredAt: Date

    var isFromToday: Bool {
        return Calendar.current.isDateInToday(registeredAt)
    }

    init(name: String, calories: Double, protein: Double,
         carbs: Double, fat: Double) {
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.registeredAt = Date()
    }
}
