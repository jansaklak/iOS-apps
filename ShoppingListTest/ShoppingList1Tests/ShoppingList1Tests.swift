import XCTest
import CoreData
@testable import ShoppingList1

final class ShoppingList1UnitTests: XCTestCase {
    var cartManager: CartManager!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        cartManager = CartManager()
        // Używamy inMemory dla izolacji testów
        context = PersistenceController(inMemory: true).container.viewContext
    }

    func testCartManagerLogicAndHelpers() {
        // 1. Inicjalizacja: Koszyk powinien być pusty
        XCTAssertEqual(cartManager.items.count, 0)
        
        // 2. Cena całkowita na początku powinna wynosić 0.0
        XCTAssertEqual(cartManager.totalPrice, 0.0)

        let product = Product(context: context)
        product.name = "Testowy Produkt"
        product.price = 10.0

        // 3. Dodanie produktu: Liczba unikalnych kluczy powinna wzrosnąć
        cartManager.addToCart(product: product)
        XCTAssertEqual(cartManager.items.count, 1)

        // 4. Ilość dodanego produktu powinna wynosić 1
        XCTAssertEqual(cartManager.items[product], 1)

        // 5. Ponowne dodanie: Ilość powinna wzrosnąć do 2
        cartManager.addToCart(product: product)
        XCTAssertEqual(cartManager.items[product], 2)

        // 6. Cena całkowita powinna wynosić 20.0 (2 * 10.0)
        XCTAssertEqual(cartManager.totalPrice, 20.0)

        // 7. Usunięcie produktu: Koszyk powinien być znów pusty
        cartManager.removeFromCart(product: product)
        XCTAssertNil(cartManager.items[product])
        XCTAssertEqual(cartManager.items.count, 0)

        // 8. Cena po usunięciu powinna wrócić do 0.0
        XCTAssertEqual(cartManager.totalPrice, 0.0)

        // 9. Helper Product: wrappedName dla nil
        let emptyProduct = Product(context: context)
        XCTAssertEqual(emptyProduct.wrappedName, "Nieznany produkt")

        // 10. Helper Product: wrappedName dla wartości
        emptyProduct.name = "Jabłko"
        XCTAssertEqual(emptyProduct.wrappedName, "Jabłko")

        // 11. Helper Product: wrappedDesc dla nil
        XCTAssertEqual(emptyProduct.wrappedDesc, "Brak opisu")

        // 12. Helper Category: wrappedName dla nil
        let category = Category(context: context)
        XCTAssertEqual(category.wrappedName, "Bez kategorii")

        // 13. Sortowanie: itemsSorted dla pustego koszyka
        XCTAssertTrue(cartManager.itemsSorted.isEmpty)

        // 14. Kolejność sortowania (Banan vs Jabłko)
        let p1 = Product(context: context); p1.name = "Jabłko"
        let p2 = Product(context: context); p2.name = "Banan"
        cartManager.addToCart(product: p1)
        cartManager.addToCart(product: p2)
        XCTAssertEqual(cartManager.itemsSorted.first?.key.name, "Banan") // B < J

        // 15. Unikalność obiektów ID w słowniku
        XCTAssertEqual(cartManager.items.keys.count, 2)

        // 16. Persistence: Sprawdzenie domyślnej ceny (defaultValue)
        let newProd = Product(context: context)
        XCTAssertEqual(newProd.price, 0.0)

        // 17. TotalPrice: Precyzja przy wielu produktach
        p1.price = 2.50
        p2.price = 4.99
        XCTAssertEqual(cartManager.totalPrice, 7.49)

        // 18. CartManager: Zachowanie przy nilowej nazwie w sortowaniu
        let p3 = Product(context: context); p3.name = nil
        cartManager.addToCart(product: p3)
        XCTAssertNoThrow(cartManager.itemsSorted)

        // 19. Core Data: Relacja origin
        p1.origin = category
        XCTAssertEqual(p1.origin?.name, category.name)

        // 20. Seedowanie: Sprawdzenie czy seedData dodaje obiekty
        PersistenceController.shared.seedData(context: context)
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let count = try? context.count(for: request)
        XCTAssertGreaterThan(count ?? 0, 0)
    }
}
