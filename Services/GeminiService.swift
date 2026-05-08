//
//  GeminiService.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
// GeminiService.swift
// Esse arquivo é responsável por se comunicar com a IA do Gemini.
// O usuário manda uma foto e uma descrição, e a IA retorna
// as informações nutricionais no formato JSON.

import Foundation
import GoogleGenerativeAI
import UIKit

@Observable
class GeminiService {

    // Aqui criamos o modelo que vamos usar.
    // "gemini-1.5-flash" é o modelo mais rápido e barato do Gemini.
    private let model = GenerativeModel(
        name: "gemini-1.5-flash",
        apiKey: APIConfig.apiKey
    )

    // Essa função recebe a descrição da refeição e uma foto opcional.
    // "async" significa que ela roda em segundo plano — o app não trava
    // enquanto espera a resposta da IA.
    // "-> String?" significa que ela devolve um texto ou nil se der erro.
    func analyzeMeal(description: String, image: UIImage?) async -> String? {

        // Esse é o texto que enviamos para a IA explicando o que queremos.
        let prompt = """
        Analise esta refeição: \(description).
        Retorne APENAS um JSON com este formato exato:
        { "name": "string", "calories": 0.0, "protein": 0.0, "carbs": 0.0, "fat": 0.0 }
        Sem markdown, sem explicação, apenas o JSON.
        """

        do {
            // Aqui verificamos se o usuário mandou uma foto.
            if let uiImage = image {

                // Se tiver foto, enviamos o texto e a imagem juntos.
                // Essa é a sintaxe correta para a versão 0.5.6 do SDK.
                let response = try await model.generateContent(prompt, uiImage)
                return response.text

            } else {

                // Se não tiver foto, enviamos só o texto.
                let response = try await model.generateContent(prompt)
                return response.text
            }

        } catch {
            // Se algo der errado, mostramos o erro no console do Xcode.
            print("Erro ao chamar o Gemini: \(error.localizedDescription)")
            return nil
        }
    }
}
