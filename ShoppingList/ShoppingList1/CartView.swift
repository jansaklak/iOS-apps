//
//  CartView.swift
//  ShoppingList1
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager // Dostęp do koszyka
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if cartManager.items.isEmpty {
                Text("Koszyk jest pusty")
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(cartManager.itemsSorted, id: \.key.objectID) { entry in
                        let product = entry.key
                        let quantity = entry.value
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.wrappedName)
                                    .font(.headline)
                                Text("Ilość: \(quantity)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(product.price * Double(quantity), specifier: "%.2f") zł")
                                .bold()
                            Button(role: .destructive) {
                                cartManager.removeFromCart(product: product)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel("Usuń \(product.wrappedName) z koszyka")
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Suma")
                            Spacer()
                            Text("\(cartManager.totalPrice, specifier: "%.2f") zł")
                                .bold()
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Koszyk")
    }
}

private extension CartManager {
    var itemsSorted: [(key: Product, value: Int)] {
        items.sorted { (lhs, rhs) in
            (lhs.key.name ?? "") < (rhs.key.name ?? "")
        }
    }
}
