import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ShoppingList1")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        seedData(context: container.viewContext)
    }
    
    func seedData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let category1 = Category(context: context)
                category1.id = UUID()
                category1.name = "Owoce"
                
                let prod1 = Product(context: context)
                prod1.id = UUID()
                prod1.name = "Jabłko"
                prod1.price = 2.50
                prod1.desc = "Świeże jabłka."
                prod1.origin = category1
                
                let prod2 = Product(context: context)
                prod2.id = UUID()
                prod2.name = "Banan"
                prod2.price = 4.99
                prod2.desc = "Banany z Ekwadoru, idealne źródło potasu."
                prod2.origin = category1
                
                let category2 = Category(context: context)
                category2.id = UUID()
                category2.name = "Pieczywo"
                
                let prod3 = Product(context: context)
                prod3.id = UUID()
                prod3.name = "Bagietka"
                prod3.price = 3.20
                prod3.desc = "Chrupiąca francuska bułka."
                prod3.origin = category2
                
                try context.save()
                print("Załadowano dane testowe (Fixtures)")
            }
        } catch {
            print("Błąd podczas ładowania danych: \(error)")
        }
    }
}
