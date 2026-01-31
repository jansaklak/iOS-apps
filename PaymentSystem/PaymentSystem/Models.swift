import Foundation

import Foundation

struct Product: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let price: Decimal
    
    init(id: UUID = UUID(), name: String, price: Decimal) {
        self.id = id
        self.name = name
        self.price = price
    }
}

struct PaymentRequest: Codable {
    let productID: UUID
    let details: PaymentDetails
}

struct PaymentDetails: Equatable, Codable {
    var cardholderName: String
    var cardNumber: String
    var expiryMonth: Int
    var expiryYear: Int
    var cvv: String
}

struct Purchase: Identifiable, Codable, Hashable {
    let id: UUID
    let product: Product
    let date: Date
    let transactionID: String
}

// MARK: - Helpers
extension Decimal: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let value = Decimal(string: string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid decimal string")
        }
        self = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

extension Decimal {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}
