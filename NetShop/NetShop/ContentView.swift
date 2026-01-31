//
//  ContentView.swift
//  NetShop
//
//  Created by Jan Sakłak on 27/12/2025.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        TabView {
            ProductListView()
                .tabItem { Label("Produkty", systemImage: "cart") }
            
            CategoryListView()
                .tabItem { Label("Kategorie", systemImage: "tag") }
            
            OrderListView()
                .tabItem { Label("Zamówienia", systemImage: "list.bullet.rectangle") }
        }
        .task {
            // Centralized sync call
            await syncAllData(context: context)
        }
    }
}

struct ProductListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)])
    var products: FetchedResults<Product>
    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            List(products) { product in
                VStack(alignment: .leading) {
                    Text(product.name ?? "Brak nazwy").font(.headline)
                    HStack {
                        Text("\(product.price, specifier: "%.2f") zł")
                        Spacer()
                        Text(product.category?.name ?? "Bez kategorii").font(.caption).foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Produkty")
            .toolbar {
                Button(action: { Task { await syncAllData(context: viewContext) } }) {
                    Image(systemName: "arrow.clockwise")
                }
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddProductView()
            }
        }
    }
}

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)])
    var categories: FetchedResults<Category>
    
    @State private var name = ""
    @State private var price = ""
    @State private var selectedCategoryId: Int64 = 1 
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Nazwa produktu", text: $name)
                TextField("Cena", text: $price).keyboardType(.decimalPad)
                
                Picker("Kategoria", selection: $selectedCategoryId) {
                    ForEach(categories) { category in
                        Text(category.name ?? "Brak nazwy").tag(category.id)
                    }
                }
                
                Button("Zapisz") {
                    Task {
                        if let priceDouble = Double(price) {
                            try? await APIService.shared.addProduct(
                                name: name,
                                price: priceDouble,
                                categoryId: Int(selectedCategoryId)
                            )
                            await syncAllData(context: viewContext)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Nowy produkt")
        }
    }
}
struct OrderListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Order.date, ascending: false)])
    private var orders: FetchedResults<Order>

    var body: some View {
        NavigationView {
            List(orders) { order in
                VStack(alignment: .leading) {
                    HStack {
                        Text("Zamówienie #\(String(order.id))").bold()
                        Spacer()
                        Text(order.status ?? "Nieznany").foregroundColor(.blue)
                    }
                    Text("Klient: \(order.userEmail ?? "Brak maila")").font(.subheadline)
                    Text("Kwota: \(order.totalAmount, specifier: "%.2f") zł").font(.headline)
                    if let date = order.date {
                        Text(date, style: .date).font(.caption)
                    }
                }
            }
            .navigationTitle("Zamówienia")
        }
    }
}
