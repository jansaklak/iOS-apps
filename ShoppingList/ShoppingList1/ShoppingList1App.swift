//
//  ShoppingList1App.swift
//  ShoppingList1
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI
import CoreData

@main
struct ShoppingList1App: App {
    let persistenceController = PersistenceController.shared
    @StateObject var cartManager = CartManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cartManager) 
        }
    }
}
