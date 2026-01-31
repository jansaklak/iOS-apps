import SwiftUI

struct MainTabView: View {
    @ObservedObject var store: PurchaseStore
    let server: MockPaymentServer

    var body: some View {
        TabView {
            NavigationStack {
                StoreProductListView(store: store, server: server)
                    .navigationTitle("Sklep")
            }
            .tabItem {
                Label("Sklep", systemImage: "cart")
            }

            NavigationStack {
                PurchasedListView(store: store)
                    .navigationTitle("Moje Zakupy")
            }
            .tabItem {
                Label("Zakupy", systemImage: "checkmark.seal")
            }
        }
    }
}
