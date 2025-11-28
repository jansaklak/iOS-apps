import Foundation

struct ToDoItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var isDone: Bool
    var symbolName: String

    init(id: UUID = UUID(), title: String, isDone: Bool = false, symbolName: String) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.symbolName = symbolName
    }
}
