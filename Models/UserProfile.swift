//
//  UserProfile.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation
import SwiftData

@Model
class UserProfile: Codable {
    var name: String
    var age: Int
    var heightcm: Double
    var weightkg: Double
    var goalweightkg: Double
    var isMale: Bool //true para homem, false para mulher
    var dailycal: Double?
    
    // logica se dailycal é manual ou automatico
    var metaCaloricaFinal: Double {
        if let manual = dailycal, manual > 0 {
            return manual
        } else {
            // cálculo automático (Mifflin-St Jeor)
            let baseTMB = (10 * weightkg) + (6.25 * heightcm) - (5 * Double(age))
            return isMale ? (baseTMB + 5) : (baseTMB - 161)
        }
    }

    init(name: String, age: Int, heightcm: Double, weightkg: Double, goalweightkg: Double, isMale: Bool, dailycal: Double? = nil) {
        self.name = name
        self.age = age
        self.heightcm = heightcm
        self.weightkg = weightkg
        self.goalweightkg = goalweightkg
        self.isMale = isMale
        self.dailycal = dailycal
    }

    //transforma os dados em json
    enum CodingKeys: String, CodingKey {
        case name, age, heightcm, weightkg, goalweightkg, isMale, dailycal
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        heightcm = try container.decode(Double.self, forKey: .heightcm)
        weightkg = try container.decode(Double.self, forKey: .weightkg)
        goalweightkg = try container.decode(Double.self, forKey: .goalweightkg)
        isMale = try container.decode(Bool.self, forKey: .isMale)
        dailycal = try container.decodeIfPresent(Double.self, forKey: .dailycal)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(heightcm, forKey: .heightcm)
        try container.encode(weightkg, forKey: .weightkg)
        try container.encode(goalweightkg, forKey: .goalweightkg)
        try container.encode(isMale, forKey: .isMale)
        try container.encodeIfPresent(dailycal, forKey: .dailycal)
    }
}
