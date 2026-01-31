//
//  ContentView.swift
//  ShoppingList1
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        TabView {
            ProductListView()
                .tabItem {
                    Label("Produkty", systemImage: "list.bullet")
                }
            NavigationStack {
                CartView()
            }
            .tabItem {
                    Label("Koszyk", systemImage: "cart.fill")
                }
                .badge(cartManager.items.count)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(CartManager())
}
