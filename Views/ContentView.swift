
import SwiftUI

struct ContentView: View {
    @StateObject private var vm: TaskListViewModel

    init(store: TaskStore) {
        _vm = StateObject(wrappedValue: TaskListViewModel(store: store))
    }

    var body: some View {
        TabView {
            TaskListScreen(vm: vm, title: "All", kind: nil, systemImage: "checklist")
                .tabItem { Label("All", systemImage: "checklist") }
            TaskListScreen(vm: vm, title: "Work", kind: .work, systemImage: "briefcase")
                .tabItem { Label("Work", systemImage: "briefcase") }
            TaskListScreen(vm: vm, title: "Personal", kind: .personal, systemImage: "person")
                .tabItem { Label("Personal", systemImage: "person") }
            TaskListScreen(vm: vm, title: "Shopping", kind: .shopping, systemImage: "cart")
                .tabItem { Label("Shopping", systemImage: "cart") }
        }
    }
}
