//
//  ShapeShiftApp.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//

// ShapeShiftApp.swift
// Ponto de entrada do app.
// Aqui criamos o AppState e o disponibilizamos para todas as telas.

import SwiftUI
import SwiftData

@main
struct ShapeShiftApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            UserProfile.self,
            Meals.self,
            FoodItem.self,
            ChecklistItem.self,
            WeightEntry.self,
            DailyLog.self
        ])
    }
}
