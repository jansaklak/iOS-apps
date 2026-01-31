import SwiftUI

@main
struct PaymentSystemApp: App {
    @StateObject private var purchaseStore = PurchaseStore()
    private let paymentServer = MockPaymentServer()

    var body: some Scene {
        WindowGroup {
            MainTabView(store: purchaseStore, server: paymentServer)
        }
    }
}
