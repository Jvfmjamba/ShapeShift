//
//  EditableFoodView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//

import Foundation

struct EditableFoodItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var weightGrams: Double
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double

    var manualCalories: Double = 0
    var manualProtein: Double = 0
    var manualCarbs: Double = 0
    var manualFat: Double = 0

    var calories: Double { caloriesPer100g > 0 ? (caloriesPer100g * weightGrams) / 100 : manualCalories }
    var protein: Double { proteinPer100g > 0 ? (proteinPer100g * weightGrams) / 100 : manualProtein }
    var carbs: Double { carbsPer100g > 0 ? (carbsPer100g * weightGrams) / 100 : manualCarbs }
    var fat: Double { fatPer100g > 0 ? (fatPer100g * weightGrams) / 100 : manualFat }
}
