import Foundation

struct ProductDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let price: Double
    let categoryId: Int

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case categoryId = "category_id"
    }
}
