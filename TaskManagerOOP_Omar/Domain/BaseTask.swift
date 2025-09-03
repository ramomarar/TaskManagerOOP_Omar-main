import Foundation

/// Base class demonstrating OOP inheritance. Concrete task types subclass this.
class BaseTask: Identifiable, ObservableObject, Completable, Schedulable, Prioritizable, DTOConvertible {
    let id: UUID
    @Published var title: String
    @Published var notes: String
    @Published var isCompleted: Bool
    @Published var createdAt: Date
    @Published var updatedAt: Date
    @Published var dueDate: Date?
    @Published var priority: TaskPriority
    let kind: TaskKind
    
    init(id: UUID = UUID(),
         title: String,
         notes: String = "",
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         dueDate: Date? = nil,
         priority: TaskPriority = .medium,
         kind: TaskKind) throws {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.dueDate = dueDate
        self.priority = priority
        self.kind = kind
        try validate()
    }
    
    func toggleComplete() { isCompleted.toggle(); updatedAt = Date() }
    
    /// Basic validation shared across subclasses
    func validate() throws {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { throw TaskError.emptyTitle }
        if let due = dueDate, due < createdAt { throw TaskError.invalidDate }
    }
    
    func touch() { updatedAt = Date() }
    
    // MARK: DTO bridge
    func toDTO() -> PersistedTaskDTO { .from(self) }
}
