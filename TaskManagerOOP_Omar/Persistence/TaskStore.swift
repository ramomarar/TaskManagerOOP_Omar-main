import Foundation

final class TaskStore: ObservableObject {
    @Published private(set) var tasks: [BaseTask] = []
    private let storageKey = "TaskManagerOOP.tasks"
    
    init() {
        do { try load() } catch { print("⚠️ Load error: \(error)") }
        if tasks.isEmpty {
            // Seed with a few examples for first run
            do {
                try add(WorkTask(title: "Prepare sprint demo", notes: "Show latest build", project: "iOS"))
                try add(PersonalTask(title: "Gym session", notes: "Leg day", tag: "Health", dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())))
                try add(ShoppingTask(title: "Milk", quantity: 2, unit: "L"))
            } catch {
                print("Seed error: \(error)")
            }
        }
    }
    
    // MARK: CRUD
    func add(_ task: BaseTask) throws {
        if tasks.map({ $0.title.lowercased() }).contains(task.title.lowercased()) {
            throw TaskError.duplicateTitle
        }
        tasks.append(task)
        try save()
    }
    
    func update(_ task: BaseTask, mutate: () -> Void) throws {
        mutate()
        task.touch()
        try task.validate()
        try save()
    }
    
    func remove(_ task: BaseTask) throws {
        tasks.removeAll { $0.id == task.id }
        try save()
    }
    
    func filtered(by kind: TaskKind?) -> [BaseTask] {
        guard let kind else { return tasks.sorted(by: sortRule) }
        return tasks.filter { $0.kind == kind }.sorted(by: sortRule)
    }
    
    private func sortRule(_ a: BaseTask, _ b: BaseTask) -> Bool {
        // High priority first, then earliest due date, then most recent updated
        if a.priority != b.priority { return a.priority == .high }
        switch (a.dueDate, b.dueDate) {
        case let (d1?, d2?): return d1 < d2
        case (_?, nil): return true
        case (nil, _?): return false
        default: return a.updatedAt > b.updatedAt
        }
    }
    
    // MARK: Persistence
    private func save() throws {
        let dtos = tasks.map { $0.toDTO() }
        do {
            let data = try JSONEncoder().encode(dtos)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            throw TaskError.persistenceFailed
        }
    }
    
    private func load() throws {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let dtos = try JSONDecoder().decode([PersistedTaskDTO].self, from: data)
            let concrete = try dtos.map { try DTOFactory.makeTask(from: $0) }
            self.tasks = concrete
        } catch {
            throw TaskError.persistenceFailed
        }
    }
}
