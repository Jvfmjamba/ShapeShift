import Foundation

enum APIConfig {
    static var backendURL: URL? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "BACKEND_URL") as? String,
              !value.isEmpty,
              !value.contains("$("),
              let url = URL(string: value) else {
            return nil
        }

        return url
    }
}
