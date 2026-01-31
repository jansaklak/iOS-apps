import Foundation
import Combine

// MARK: - Mock Server Application
/// Symuluje zewnętrzną aplikację serwerową
actor PaymentBackend {
    enum BackendError: Error, LocalizedError {
        case invalidCard, expiredCard, insufficientFunds, networkError
        
        var errorDescription: String? {
            switch self {
            case .invalidCard: return "Serwer odrzucił kartę: nieprawidłowy numer."
            case .expiredCard: return "Serwer odrzucił kartę: data ważności wygasła."
            case .insufficientFunds: return "Brak środków na koncie (Symulacja)."
            case .networkError: return "Błąd połączenia z serwerem płatności."
            }
        }
    }

    func processTransaction(request: PaymentRequest, product: Product) async throws -> String {
        // Symulacja opóźnienia sieciowego
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        guard luhnCheck(request.details.cardNumber) else { throw BackendError.invalidCard }
        
        let now = Date()
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)
        if request.details.expiryYear < year || (request.details.expiryYear == year && request.details.expiryMonth < month) {
            throw BackendError.expiredCard
        }
        
        if Int.random(in: 0...9) == 0 { throw BackendError.insufficientFunds }
        
        return "TXN-\(UUID().uuidString.prefix(8))"
    }

    private func luhnCheck(_ number: String) -> Bool {
        let digits = number.replacingOccurrences(of: " ", with: "").compactMap { Int(String($0)) }
        guard digits.count >= 13 else { return false }
        var sum = 0
        for (idx, digit) in digits.reversed().enumerated() {
            if idx % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}

// MARK: - Local Purchase Store
/// Zarządza lokalnym modelem zakupionych produktów (Persistence)
final class PurchaseStore: ObservableObject {
    @Published private(set) var purchasedItems: [Purchase] = []
    private let saveKey = "SavedPurchases"

    init() {
        loadFromDisk()
    }

    @MainActor
    func addPurchase(_ purchase: Purchase) {
        purchasedItems.insert(purchase, at: 0)
        saveToDisk()
    }

    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(purchasedItems) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadFromDisk() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Purchase].self, from: data) {
            purchasedItems = decoded
        }
    }
}
