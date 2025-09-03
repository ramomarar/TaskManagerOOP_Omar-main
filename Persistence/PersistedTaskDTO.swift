
import Foundation

/// Neutral persistence representation to avoid complexity of class-graph Codable
struct PersistedTaskDTO: Codable, Identifiable {
    let id: UUID
    let kind: TaskKind
    var title: String
    var notes: String
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    var dueDate: Date?
    var priority: TaskPriority

    // Type-specific fields
    var project: String?      // WorkTask
    var tag: String?          // PersonalTask
    var quantity: Int?        // ShoppingTask
    var unit: String?
}

extension PersistedTaskDTO {
    static func from(_ base: BaseTask) -> PersistedTaskDTO {
        var dto = PersistedTaskDTO(id: base.id, kind: base.kind, title: base.title, notes: base.notes, isCompleted: base.isCompleted, createdAt: base.createdAt, updatedAt: base.updatedAt, dueDate: base.dueDate, priority: base.priority, project: nil, tag: nil, quantity: nil, unit: nil)
        switch base {
        case let w as WorkTask:
            dto.project = w.project
        case let p as PersonalTask:
            dto.tag = p.tag
        case let s as ShoppingTask:
            dto.quantity = s.quantity
            dto.unit = s.unit
        default: break
        }
        return dto
    }
}

struct DTOFactory {
    static func makeTask(from dto: PersistedTaskDTO) throws -> BaseTask {
        switch dto.kind {
        case .work:
            return try WorkTask(id: dto.id, title: dto.title, notes: dto.notes, project: dto.project ?? "General", isCompleted: dto.isCompleted, createdAt: dto.createdAt, updatedAt: dto.updatedAt, dueDate: dto.dueDate, priority: dto.priority)
        case .personal:
            return try PersonalTask(id: dto.id, title: dto.title, notes: dto.notes, tag: dto.tag, isCompleted: dto.isCompleted, createdAt: dto.createdAt, updatedAt: dto.updatedAt, dueDate: dto.dueDate, priority: dto.priority)
        case .shopping:
            return try ShoppingTask(id: dto.id, title: dto.title, notes: dto.notes, quantity: dto.quantity ?? 1, unit: dto.unit ?? "pcs", isCompleted: dto.isCompleted, createdAt: dto.createdAt, updatedAt: dto.updatedAt, dueDate: dto.dueDate, priority: dto.priority)
        }
    }
}
