//
//  GeminiService.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
// GeminiService.swift


import Foundation
import GoogleGenerativeAI
import UIKit

@Observable
class GeminiService {

    private let model = GenerativeModel(
        name: "gemini-1.5-flash",
        apiKey: APIConfig.apiKey
    )

    func analyzeMeal(description: String, image: UIImage?) async -> String? {

        let prompt = """
        Analise esta refeição: \(description).
        Retorne APENAS um JSON com este formato exato:
        { "name": "string", "calories": 0.0, "protein": 0.0, "carbs": 0.0, "fat": 0.0 }
        Sem markdown, sem explicação, apenas o JSON.
        """

        do {
            
            if let uiImage = image {

                
                
                let response = try await model.generateContent(prompt, uiImage)
                return response.text

            } else {

                
                let response = try await model.generateContent(prompt)
                return response.text
            }

        } catch {
            
            print("Erro ao chamar o Gemini: \(error)")
            return nil
        }
    }
}

