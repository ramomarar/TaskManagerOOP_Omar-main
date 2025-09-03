
import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: BaseTask
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                HStack(spacing: 8) {
                    if let due = task.dueDate { Text(due, style: .date) }
                    Text(task.priority.rawValue.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(priorityColor(task.priority).opacity(0.15))
                        .clipShape(Capsule())
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Text(task.kind.displayName)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.thinMaterial)
                .clipShape(Capsule())
        }
    }

    func priorityColor(_ p: TaskPriority) -> Color {
        switch p {
        case .low:    return .blue
        case .medium: return .orange
        case .high:   return .red
        }
    }
}
