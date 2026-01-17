import Foundation
import Combine

class AuthService: ObservableObject {
    
    static let shared = AuthService()
    
    @Published var token: String? {
        didSet {
            isLoggedIn = token != nil
        }
    }
    @Published var isLoggedIn: Bool = false

    private init(token: String? = nil, isLoggedIn: Bool = false) {
        self.token = token
        self.isLoggedIn = isLoggedIn
    }

    func login(email: String, password: String) async {
        guard let url = URL(string: "http://localhost:3000/auth/login") else { return }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email, "password": password]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: req)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let receivedToken = json["token"] as? String {
                await MainActor.run {
                    self.token = receivedToken
                }
            }
        } catch {
            print("Błąd logowania: \(error)")
        }
    }
}
