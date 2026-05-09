//  GeminiService.swift
//  ShapeShift
//
//  Created by João Vitor Franca on 08/05/26.
//

import Foundation
import UIKit

@Observable
class GeminiService {

    private let apiURL = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent"

    func analyzeMeal(description: String, image: UIImage?) async -> String? {

        guard let url = URL(string: "\(apiURL)?key=\(APIConfig.apiKey)") else {
            print("URL inválida")
            return nil
        }

        let prompt = """
        Analise esta refeição: \(description).
        Identifique cada alimento separadamente.

        REGRAS IMPORTANTES:
        - Se o usuário informou a quantidade de um alimento na descrição, use exatamente essa quantidade.
        - Para alimentos que aparecem na foto mas não foram mencionados, estime a quantidade visualmente.
        - Retorne APENAS um JSON com este formato exato, sem markdown, sem explicação:
        {
          "mealName": "string",
          "items": [
            {
              "name": "string",
              "weightGrams": 0.0,
              "caloriesPer100g": 0.0,
              "proteinPer100g": 0.0,
              "carbsPer100g": 0.0,
              "fatPer100g": 0.0
            }
          ]
        }
        """

        let textPart: [String: Any] = ["text": prompt]
        var parts: [[String: Any]] = [textPart]

        if let uiImage = image,
           let imageData = uiImage.jpegData(compressionQuality: 0.8) {
            let base64String = imageData.base64EncodedString()
            let imagePart: [String: Any] = [
                "inlineData": [
                    "mimeType": "image/jpeg",
                    "data": base64String
                ]
            ]
            parts.append(imagePart)
        }

        let requestBody: [String: Any] = [
            "contents": [["parts": parts]]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Erro ao montar o JSON da requisição")
            return nil
        }

        request.httpBody = httpBody

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            if let responseString = String(data: data, encoding: .utf8) {
                print("Resposta do Gemini: \(responseString)")
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]],
                  let firstCandidate = candidates.first,
                  let content = firstCandidate["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let firstPart = parts.first,
                  let text = firstPart["text"] as? String
            else {
                print("Erro ao ler a resposta do Gemini")
                return nil
            }

            return text

        } catch {
            print("Erro na chamada da API: \(error)")
            return nil
        }
    }
}
