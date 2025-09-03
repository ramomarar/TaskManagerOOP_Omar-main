import SwiftUI

struct TaskListScreen: View {
    @EnvironmentObject private var store: TaskStore
    @ObservedObject var vm: TaskListViewModel
    let title: String
    let kind: TaskKind?
    let systemImage: String
    
    @State private var showForm = false
    @State private var editingTask: BaseTask? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.filtered(by: kind)) { task in
                    TaskRow(task: task, onToggle: { vm.toggle(task) })
                        .contentShape(Rectangle())
                        .onTapGesture { editingTask = task; showForm = true }
                }
                .onDelete { indexSet in
                    indexSet.map { store.filtered(by: kind)[$0] }.forEach { vm.remove($0) }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { editingTask = nil; showForm = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showForm) {
                TaskForm(kind: kind, taskToEdit: editingTask) { result in
                    switch result {
                    case .created(let new): vm.add(task: new)
                    case .updated(let existing):
                        do { try store.update(existing) {} }
                        catch { vm.alert = ("Save failed", (error as? LocalizedError)?.errorDescription ?? String(describing: error)) }
                    case .cancelled: break
                    }
                }
            }
            .alert(item: Binding(
                get: { vm.alert.map { AlertItem(title: $0.title, message: $0.message) } },
                set: { _ in vm.alert = nil })) { item in
                    Alert(title: Text(item.title), message: Text(item.message), dismissButton: .default(Text("OK")))
                }
        }
    }
}

private struct AlertItem: Identifiable { let id = UUID(); let title: String; let message: String }
