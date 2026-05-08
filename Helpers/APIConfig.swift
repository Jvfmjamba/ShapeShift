//
//  APIConfig.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
import Foundation

enum APIConfig {
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            // debugando
            fatalError("ERRO CRÍTICO: API_KEY não encontrada. Verifique o Secrets.xcconfig e o Info.plist.")
        }
        return key
    }
}
