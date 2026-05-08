//
//  ChecklistItem.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation

struct ChecklistItem: Codable, Identifiable{
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var lastCompletedDate: Date?
    
    var isCompletedToday: Bool{
        guard let date = lastCompletedDate else {return false}
        return Calendar.current.isDateInToday(date)
    }
}
