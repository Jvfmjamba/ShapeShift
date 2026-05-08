//
//  ShapeShiftApp.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//

import SwiftUI
import SwiftData

@main
struct ShapeShiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Progress.self)
    }
}
