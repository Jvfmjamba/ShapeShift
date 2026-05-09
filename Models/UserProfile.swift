//
//  UserProfile.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
// UserProfile.swift
// Define como é um perfil de usuário no app.
// Usamos struct + Codable para salvar no UserDefaults.

import Foundation
import SwiftData

@Model
class UserProfile {
    var name: String
    var age: Int
    var heightCm: Double
    var weightKg: Double
    var goalWeightKg: Double
    var isMale: Bool
    var dailyCal: Double?
    var createdAt: Date

    var metaCaloricaFinal: Double {
        if let manual = dailyCal, manual > 0 {
            return manual
        }
        let baseTMB = (10 * weightKg) + (6.25 * heightCm) - (5 * Double(age))
        return isMale ? (baseTMB + 5) : (baseTMB - 161)
    }

    init(name: String, age: Int, heightCm: Double, weightKg: Double,
         goalWeightKg: Double, isMale: Bool, dailyCal: Double? = nil) {
        self.name = name
        self.age = age
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.goalWeightKg = goalWeightKg
        self.isMale = isMale
        self.dailyCal = dailyCal
        self.createdAt = Date()
    }
}
