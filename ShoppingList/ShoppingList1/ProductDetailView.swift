//
//  ProductDetailView.swift
//  ShoppingList1
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager // Dostęp do koszyka
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(product.wrappedName)
                .font(.largeTitle)
                .bold()
            
            Text("\(product.price, specifier: "%.2f") zł")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Divider()
            
            Text("Opis produktu")
                .font(.headline)
            
            Text(product.wrappedDesc)
                .font(.body)
            
            Spacer()
            
            Button(action: {
                cartManager.addToCart(product: product)
            }) {
                HStack {
                    Image(systemName: "cart.badge.plus")
                    Text("Dodaj do koszyka")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle(product.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
