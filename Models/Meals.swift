//
//  Meals.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation
import SwiftData

@Model
final class Meals {
    var id: UUID
    var name: String
    var details: String? //descricao da refeicao
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var timestamp: Date
    
    @Attribute(.externalStorage) var photoData: Data? //recebe a foto (opcional)
    
    init(
        name: String,
        details: String? = nil,
        calories: Double = 0,
        protein: Double = 0,
        carbs: Double = 0,
        fat: Double = 0,
        photoData: Data? = nil,
        timestamp: Date = Date()
    ) {
        self.id = UUID()
        self.name = name
        self.details = details
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.photoData = photoData
        self.timestamp = timestamp
    }
}
