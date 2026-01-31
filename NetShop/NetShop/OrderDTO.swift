import Foundation

struct OrderDTO: Codable, Identifiable {
    let id: Int
    let date: String
    let totalAmount: Double
    let status: String
    let userEmail: String
    let productIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id, date, status
        case totalAmount = "total_amount"
        case userEmail = "user_email"
        case productIds = "product_ids"
    }
}
