//
//  DailyLog.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
import Foundation
import SwiftData

@Model
final class DailyLog {
    var date: Date
    var calConsumed: Double
    var waterConsumed: Double
    
    init(date: Date, calConsumed: Double, waterConsumed: Double) {
        self.date = date
        self.calConsumed = calConsumed
        self.waterConsumed = waterConsumed
    }
    
}
