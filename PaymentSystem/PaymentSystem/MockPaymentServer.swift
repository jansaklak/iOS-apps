//
//  MockPaymentServer.swift
//  PaymentSystem
//
//  Created by Jan Sakłak on 24/01/2026.
//

import Foundation

// MARK: - Mock Payment Server
/// Symuluje zewnętrzną logikę serwerową
final class MockPaymentServer {
    let products: [Product] = [
        Product(name: "E-book: Swift Podstawy", price: 29.99),
        Product(name: "Kurs iOS Pro", price: 199.00),
        Product(name: "Pakiet Icon Pack", price: 9.99)
    ]

    enum ServerError: Error, LocalizedError {
        case invalidCard, expiredCard, insufficientFunds, network
        var errorDescription: String? {
            switch self {
            case .invalidCard: return "Nieprawidłowe dane karty."
            case .expiredCard: return "Karta wygasła."
            case .insufficientFunds: return "Niewystarczające środki na koncie."
            case .network: return "Błąd sieci serwera. Spróbuj ponownie."
            }
        }
    }

    func processPayment(details: PaymentDetails, product: Product) async throws -> String {
        // Symulacja opóźnienia sieciowego
        try await Task.sleep(nanoseconds: 1_200_000_000)

        // 1. Walidacja numeru karty (Luhn)
        guard luhnValidate(details.cardNumber) else { throw ServerError.invalidCard }
        
        // 2. Symulacja losowego błędu sieci (5% szans)
        if Int.random(in: 1...20) == 1 { throw ServerError.network }

        // Zwracamy unikalny ID transakcji z "serwera"
        return "TX-\(UUID().uuidString.prefix(8))"
    }

    private func luhnValidate(_ number: String) -> Bool {
        let cleanNumber = number.replacingOccurrences(of: " ", with: "")
        guard cleanNumber.count >= 13 else { return false }
        var sum = 0
        let digits = cleanNumber.compactMap { Int(String($0)) }
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
