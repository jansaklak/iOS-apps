import Foundation
import CoreData

extension Product {
    var wrappedName: String { name ?? "Nieznany produkt" }
    var wrappedDesc: String { desc ?? "Brak opisu" }
}

extension Category {
    var wrappedName: String { name ?? "Bez kategorii" }
}
