import Foundation
import CoreData

class APIService {
    static let shared = APIService()
    let baseURL = "http://127.0.0.1:8000"

    func fetchProducts() async throws -> [ProductDTO] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "\(baseURL)/products")!)
        return try JSONDecoder().decode([ProductDTO].self, from: data)
    }

    func fetchCategories() async throws -> [CategoryDTO] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "\(baseURL)/categories")!)
        return try JSONDecoder().decode([CategoryDTO].self, from: data)
    }

    func fetchOrders() async throws -> [OrderDTO] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "\(baseURL)/orders")!)
        return try JSONDecoder().decode([OrderDTO].self, from: data)
    }

    func addProduct(name: String, price: Double, categoryId: Int) async throws {
        var request = URLRequest(url: URL(string: "\(baseURL)/products")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "id": Int.random(in: 1000...9999),
            "name": name,
            "price": price,
            "category_id": categoryId
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
    }
}

@MainActor
func syncAllData(context: NSManagedObjectContext) async {
    do {
        let categoriesDTO = try await APIService.shared.fetchCategories()
        let productsDTO = try await APIService.shared.fetchProducts()
        let ordersDTO = try await APIService.shared.fetchOrders()

        context.performAndWait {
            // Synchronize Categories
            for dto in categoriesDTO {
                let request: NSFetchRequest<Category> = Category.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", dto.id)
                let category = (try? context.fetch(request).first) ?? Category(context: context)
                category.id = Int64(dto.id)
                category.name = dto.name
            }

            // Synchronize Products
            for dto in productsDTO {
                let request: NSFetchRequest<Product> = Product.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", dto.id)
                let product = (try? context.fetch(request).first) ?? Product(context: context)
                product.id = Int64(dto.id)
                product.name = dto.name
                product.price = dto.price
                
                // Link Category
                let catRequest: NSFetchRequest<Category> = Category.fetchRequest()
                catRequest.predicate = NSPredicate(format: "id == %d", dto.categoryId)
                if let category = try? context.fetch(catRequest).first {
                    product.category = category
                }
            }
            
            // Synchronize Orders
            let formatter = ISO8601DateFormatter()
            for dto in ordersDTO {
                let request: NSFetchRequest<Order> = Order.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", dto.id)
                let order = (try? context.fetch(request).first) ?? Order(context: context)
                
                order.id = Int64(dto.id)
                order.status = dto.status
                order.totalAmount = dto.totalAmount
                order.userEmail = dto.userEmail
                order.date = formatter.date(from: dto.date)

                let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
                productRequest.predicate = NSPredicate(format: "id IN %@", dto.productIds)
                if let foundProducts = try? context.fetch(productRequest) {
                    order.products = NSSet(array: foundProducts)
                }
            }

            try? context.save()
        }
    } catch {
        print("Błąd synchronizacji: \(error)")
    }
}
