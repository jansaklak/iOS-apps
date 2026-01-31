//
//  ContentView.swift
//  ToDoList
//
//  Created by Jan Sakłak on 20/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [ToDoItem] = [
        ToDoItem(title: "Kup mleko", isDone: false, symbolName: ""),
        ToDoItem(title: "Zrób zadanie", isDone: true, symbolName: ""),
        ToDoItem(title: "Bieganie", isDone: false, symbolName: ""),
        ToDoItem(title: "Posprzątaj", isDone: true, symbolName: "")
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach($items) { $item in
                    HStack(spacing: 10) {
                        TextField("Nazwa zadania", text: $item.title)
                            .strikethrough(item.isDone, color: .secondary)
                            .foregroundStyle(item.isDone ? .secondary : .primary)
                            .submitLabel(.done)
                        
                        Spacer()

                        Button {
                            withAnimation {
                                item.isDone.toggle()
                            }
                        } label: {
                            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.isDone ? .green : .gray)
                                .imageScale(.large)
                                .accessibilityLabel(item.isDone ? "Zadanie ukończone" : "Zadanie nieukończone")
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Zadania")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addTask()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Dodaj zadanie")
                }
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    private func addTask() {
        let newItem = ToDoItem(title: "", isDone: false, symbolName: "")
        withAnimation {
            items.insert(newItem, at: 0)
        }
    }
}

#Preview {
    ContentView()
}
