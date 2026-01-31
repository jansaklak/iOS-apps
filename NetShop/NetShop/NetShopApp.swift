//
//  NetShopApp.swift
//  NetShop
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI
import CoreData

@main
struct NetShopApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
