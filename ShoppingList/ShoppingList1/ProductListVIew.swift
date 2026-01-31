//
//  ProductListVIew.swift
//  ShoppingList1
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI
import CoreData

struct ProductListView: View {
    @EnvironmentObject var cartManager: CartManager

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationStack {
            List {
                ForEach(products, id: \.objectID) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.wrappedName)
                                    .font(.headline)
                                Text("\(product.price, specifier: "%.2f") zł")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                cartManager.addToCart(product: product)
                            } label: {
                                Image(systemName: "cart.badge.plus")
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel("Dodaj \(product.wrappedName) do koszyka")
                        }
                    }
                }
            }
            .navigationTitle("Produkty")
        }
    }
}
