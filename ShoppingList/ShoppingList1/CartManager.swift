import SwiftUI
import Combine

class CartManager: ObservableObject {
    @Published var items: [Product: Int] = [:]
    
    var totalPrice: Double {
        items.reduce(0) { sum, element in
            sum + (element.key.price * Double(element.value))
        }
    }
    
    func addToCart(product: Product) {
        if let currentQuantity = items[product] {
            items[product] = currentQuantity + 1
        } else {
            items[product] = 1
        }
    }
    
    func removeFromCart(product: Product) {
        items[product] = nil
    }
}
