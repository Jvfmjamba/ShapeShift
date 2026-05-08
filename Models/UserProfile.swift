//
//  UserProfile.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation
import SwiftData

@Model
class UserProfile: Codable{
    var name: String
    var age: Int
    var heightcm: Double
    var weightkg: Double
    var goalweightkg: Double
    
    //construtor de swift
    init(name: String, age: Int, heightcm: Double, weightkg: Double, goalweightkg: Double) {
        self.name = name
        self.age = age
        self.heightcm = heightcm
        self.weightkg = weightkg
        self.goalweightkg = goalweightkg
    }
    //transforma os dados em json para leitura
    enum CodingKeys: CodingKey{
        case name, age, heightcm, weightkg, goalweightkg
    }
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            age = try container.decode(Int.self, forKey: .age)
            heightcm = try container.decode(Double.self, forKey: .heightcm)
            weightkg = try container.decode(Double.self, forKey: .weightkg)
            goalweightkg = try container.decode(Double.self, forKey: .goalweightkg)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(age, forKey: .age)
            try container.encode(heightcm, forKey: .heightcm)
            try container.encode(weightkg, forKey: .weightkg)
            try container.encode(goalweightkg, forKey: .goalweightkg)
        }
}
