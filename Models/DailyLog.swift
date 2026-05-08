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
    
    init(date: Date=Date(), calConsumed: Double=0, waterConsumed: Double=0) {
        self.date = date
        self.calConsumed = calConsumed
        self.waterConsumed = waterConsumed
    }
    
}
