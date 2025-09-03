import Foundation

enum TaskPriority: String, CaseIterable, Codable, Identifiable {
    case low, medium, high
    var id: String { rawValue }
}

enum TaskKind: String, CaseIterable, Codable, Identifiable {
    case work, personal, shopping
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .work: return "Work"
        case .personal: return "Personal"
        case .shopping: return "Shopping"
        }
    }
}
