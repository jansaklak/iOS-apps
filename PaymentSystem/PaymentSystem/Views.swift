import SwiftUI

struct StoreProductListView: View {
    let store: PurchaseStore
    let server: MockPaymentServer
    
    let products = [
        Product(name: "E-book: SwiftUI Masterclass", price: 49.99),
        Product(name: "Kurs: Architektura iOS", price: 299.00),
        Product(name: "Zestaw Ikon Premium", price: 19.00)
    ]
    
    @State private var selectedProduct: Product?

    var body: some View {
        List(products) { product in
            HStack {
                VStack(alignment: .leading) {
                    Text(product.name).font(.headline)
                    Text(product.price.currencyString).foregroundStyle(.secondary)
                }
                Spacer()
                Button("Kupuję") { selectedProduct = product }
                    .buttonStyle(.borderedProminent)
            }
        }
        .sheet(item: $selectedProduct) { product in
            NavigationStack {
                PaymentFormView(product: product) { details in
                    let txID = try await server.processPayment(details: details, product: product)
                    
                    let newPurchase = Purchase(id: UUID(), product: product, date: Date(), transactionID: txID)
                    await store.addPurchase(newPurchase)
                }
            }
        }
    }
}

