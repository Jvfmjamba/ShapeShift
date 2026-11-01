import Foundation
import UIKit

@Observable
class GeminiService {

    private struct BackendResponse: Decodable {
        let result: String
    }

    func analyzeMeal(description: String, image: UIImage?) async -> String? {
        guard let baseURL = APIConfig.backendURL else {
            print("URL do backend não configurada. Defina BACKEND_URL no Info.plist.")
            return nil
        }

        let url = baseURL.appendingPathComponent("analyze")
        var payload: [String: Any] = [
            "description": description
        ]

        if let uiImage = image,
           let imageData = uiImage.jpegData(compressionQuality: 0.8) {
            payload["imageBase64"] = imageData.base64EncodedString()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Erro ao montar o JSON da requisição")
            return nil
        }

        request.httpBody = httpBody

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("O backend retornou uma resposta inválida.")
                return nil
            }

            let backendResponse = try JSONDecoder().decode(BackendResponse.self, from: data)
            return backendResponse.result
        } catch {
            print("Erro na chamada do backend: \(error)")
            return nil
        }
    }
}
