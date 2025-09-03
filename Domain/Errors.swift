
import Foundation

enum TaskError: LocalizedError, Equatable {
    case emptyTitle
    case duplicateTitle
    case invalidDate
    case persistenceFailed

    var errorDescription: String? {
        switch self {
        case .emptyTitle: return "Title can't be empty."
        case .duplicateTitle: return "A task with this title already exists."
        case .invalidDate: return "The due date is invalid."
        case .persistenceFailed: return "Saving or loading tasks failed."
        }
    }
}
