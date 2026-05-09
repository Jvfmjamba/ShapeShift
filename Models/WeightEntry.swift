//
//  WeightEntry.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation
import SwiftData

@Model
class WeightEntry {
    var weightKg: Double
    var registeredAt: Date

    init(weightKg: Double) {
        self.weightKg = weightKg
        self.registeredAt = Date()
    }
}
