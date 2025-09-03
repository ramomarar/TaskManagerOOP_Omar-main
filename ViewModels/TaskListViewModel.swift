
import Foundation

@MainActor
final class TaskListViewModel: ObservableObject {
    @Published var showForm = false
    @Published var activeKind: TaskKind? = nil
    @Published var alert: (title: String, message: String)? = nil

    private let store: TaskStore

    init(store: TaskStore) { self.store = store }

    var tasks: [BaseTask] { store.filtered(by: activeKind) }

    func add(task: BaseTask) {
        do { try store.add(task) }
        catch { alert = ("Couldn't add task", (error as? LocalizedError)?.errorDescription ?? String(describing: error)) }
    }

    func remove(_ task: BaseTask) {
        do { try store.remove(task) }
        catch { alert = ("Couldn't delete", (error as? LocalizedError)?.errorDescription ?? String(describing: error)) }
    }

    func toggle(_ task: BaseTask) {
        do { try store.update(task) { task.toggleComplete() } }
        catch { alert = ("Update failed", (error as? LocalizedError)?.errorDescription ?? String(describing: error)) }
    }
}
