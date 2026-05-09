//
//  DailyLog.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
import Foundation
import SwiftData

@Model
class DailyLog {
    var date: Date
    var waterConsumed: Double
    var calConsumed: Double

    init() {
        self.date = Calendar.current.startOfDay(for: Date())
        self.waterConsumed = 0.0
        self.calConsumed = 0.0
    }
}
