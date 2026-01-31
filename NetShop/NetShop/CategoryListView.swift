//
//  CategoryListView.swift
//  NetShop
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI
import CoreData

struct CategoryListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)])
    private var categories: FetchedResults<Category>

    var body: some View {
        NavigationView {
            List {
                if categories.isEmpty {
                    Text("Brak kategorii")
                } else {
                    ForEach(categories) { category in
                        Text(category.name ?? "—")
                    }
                }
            }
            .navigationTitle("Kategorie")
        }
    }
}

#Preview {
    CategoryListView()
}
