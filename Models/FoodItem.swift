//
//  FoodView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
import Foundation
import SwiftData

@Model
class FoodItem {
    var name: String
    var weightGrams: Double
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double
    var meal: Meals?

    var calories: Double { (caloriesPer100g * weightGrams) / 100 }
    var protein: Double { (proteinPer100g * weightGrams) / 100 }
    var carbs: Double { (carbsPer100g * weightGrams) / 100 }
    var fat: Double { (fatPer100g * weightGrams) / 100 }

    init(name: String, weightGrams: Double, caloriesPer100g: Double,
         proteinPer100g: Double, carbsPer100g: Double, fatPer100g: Double) {
        self.name = name
        self.weightGrams = weightGrams
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.carbsPer100g = carbsPer100g
        self.fatPer100g = fatPer100g
    }
}
