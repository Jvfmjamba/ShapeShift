//
//  ChecklistItem.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation
import SwiftData

@Model
class ChecklistItem {
    var title: String
    var isCompleted: Bool
    var lastCompletedDate: Date?

    var isCompletedToday: Bool {
        guard let date = lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(date)
    }

    init(title: String) {
        self.title = title
        self.isCompleted = false
        self.lastCompletedDate = nil
    }
}
