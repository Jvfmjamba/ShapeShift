//
//  Progress.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//

import Foundation
import SwiftData

@Model
final class Progress {
    var timestamp: Date
    
    init(timestamp: Date = .now) {
        self.timestamp = timestamp
    }
}
