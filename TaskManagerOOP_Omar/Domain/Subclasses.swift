import Foundation

/// Work tasks add a project association (example of inheritance adding behavior)
final class WorkTask: BaseTask {
    @Published var project: String
    
    init(id: UUID = UUID(),
         title: String,
         notes: String = "",
         project: String = "General",
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         dueDate: Date? = nil,
         priority: TaskPriority = .medium) throws {
        self.project = project
        try super.init(id: id, title: title, notes: notes, isCompleted: isCompleted, createdAt: createdAt, updatedAt: updatedAt, dueDate: dueDate, priority: priority, kind: .work)
    }
}

/// Personal tasks demonstrate composition via an optional tag (e.g., Health, Family)
final class PersonalTask: BaseTask {
    @Published var tag: String?
    
    init(id: UUID = UUID(),
         title: String,
         notes: String = "",
         tag: String? = nil,
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         dueDate: Date? = nil,
         priority: TaskPriority = .medium) throws {
        self.tag = tag
        try super.init(id: id, title: title, notes: notes, isCompleted: isCompleted, createdAt: createdAt, updatedAt: updatedAt, dueDate: dueDate, priority: priority, kind: .personal)
    }
}

/// Shopping tasks add quantity and unit
final class ShoppingTask: BaseTask {
    @Published var quantity: Int
    @Published var unit: String
    
    init(id: UUID = UUID(),
         title: String,
         notes: String = "",
         quantity: Int = 1,
         unit: String = "pcs",
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         dueDate: Date? = nil,
         priority: TaskPriority = .medium) throws {
        self.quantity = quantity
        self.unit = unit
        try super.init(id: id, title: title, notes: notes, isCompleted: isCompleted, createdAt: createdAt, updatedAt: updatedAt, dueDate: dueDate, priority: priority, kind: .shopping)
    }
}
