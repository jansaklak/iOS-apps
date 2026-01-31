import SwiftUI

struct PurchasedListView: View {
    @ObservedObject var store: PurchaseStore
    
    var body: some View {
        List(store.purchasedItems) { purchase in
            VStack(alignment: .leading) {
                Text(purchase.product.name)
                    .font(.headline)
                Text("Kupiono: \(purchase.date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Transakcja: \(purchase.transactionID)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 6)
        }
        .listStyle(.insetGrouped)
        .overlay(
            Group {
                if store.purchasedItems.isEmpty {
                    ContentUnavailableView("Brak zakupów", systemImage: "cart.badge.question", description: Text("Nie dokonałeś jeszcze żadnego zakupu."))
                }
            }
        )
    }
}
