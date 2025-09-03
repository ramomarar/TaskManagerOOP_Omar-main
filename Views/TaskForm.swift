
import SwiftUI

struct TaskForm: View {
    enum Result { case created(BaseTask), updated(BaseTask), cancelled }

    let kind: TaskKind?
    var taskToEdit: BaseTask?
    var onDone: (Result) -> Void

    // Common fields
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var dueDate: Date? = nil
    @State private var hasDueDate: Bool = false
    @State private var priority: TaskPriority = .medium
    @State private var selectedKind: TaskKind = .work

    // Type-specific
    @State private var project: String = "General"      // Work
    @State private var tag: String = ""                 // Personal
    @State private var quantity: Int = 1                // Shopping
    @State private var unit: String = "pcs"

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: TaskStore

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes, axis: .vertical)
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases) { Text($0.rawValue.capitalized).tag($0) }
                    }
                    Toggle("Has due date", isOn: $hasDueDate.animation())
                    if hasDueDate {
                        DatePicker("Due", selection: Binding(get: { dueDate ?? Date() }, set: { dueDate = $0 }), displayedComponents: [.date, .hourAndMinute])
                    }
                }
                Section("Type") {
                    Picker("Kind", selection: $selectedKind) {
                        ForEach(TaskKind.allCases) { Text($0.displayName).tag($0) }
                    }
                    switch selectedKind {
                    case .work:
                        TextField("Project", text: $project)
                    case .personal:
                        TextField("Tag (optional)", text: $tag)
                    case .shopping:
                        Stepper(value: $quantity, in: 1...999) { Text("Quantity: \(quantity)") }
                        TextField("Unit", text: $unit)
                    }
                }
            }
            .navigationTitle(taskToEdit == nil ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss(); onDone(.cancelled) }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .onAppear { hydrateFromEdit() }
        }
    }

    private func hydrateFromEdit() {
        if let t = taskToEdit {
            title = t.title
            notes = t.notes
            priority = t.priority
            dueDate = t.dueDate
            hasDueDate = t.dueDate != nil
            selectedKind = t.kind
            switch t {
            case let w as WorkTask: project = w.project
            case let p as PersonalTask: tag = p.tag ?? ""
            case let s as ShoppingTask: quantity = s.quantity; unit = s.unit
            default: break
            }
        } else if let k = kind {
            selectedKind = k
        }
    }

    private func save() {
        do {
            let base: BaseTask
            switch selectedKind {
            case .work:
                base = try WorkTask(title: title, notes: notes, project: project, dueDate: hasDueDate ? dueDate : nil, priority: priority)
            case .personal:
                base = try PersonalTask(title: title, notes: notes, tag: tag.isEmpty ? nil : tag, dueDate: hasDueDate ? dueDate : nil, priority: priority)
            case .shopping:
                base = try ShoppingTask(title: title, notes: notes, quantity: quantity, unit: unit, dueDate: hasDueDate ? dueDate : nil, priority: priority)
            }
            if let editing = taskToEdit {
                // Copy across fields to the existing instance
                editing.title = base.title
                editing.notes = base.notes
                editing.priority = base.priority
                editing.dueDate = base.dueDate
                if let w = editing as? WorkTask, let nw = base as? WorkTask { w.project = nw.project }
                if let p = editing as? PersonalTask, let np = base as? PersonalTask { p.tag = np.tag }
                if let s = editing as? ShoppingTask, let ns = base as? ShoppingTask { s.quantity = ns.quantity; s.unit = ns.unit }
                onDone(.updated(editing))
            } else {
                onDone(.created(base))
            }
            dismiss()
        } catch {
            print("Validation error: \(error)")
        }
    }
}
