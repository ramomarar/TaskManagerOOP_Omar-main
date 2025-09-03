import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TaskStore
    @StateObject private var vm: TaskListViewModel
    
    init() {
        // Will be replaced by environment injection in onAppear
        _vm = StateObject(wrappedValue: TaskListViewModel(store: TaskStore()))
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
        .onAppear {
            // Reconnect the VM to the injected store
            if vm.tasks.isEmpty { vm.setValue(forKey: "store", value: store) }
        }
    }
}

// Small hack to set private property via reflection; alternative is init(store:) from parent but TabView makes it verbose.
extension ObservableObject {
    fileprivate func setValue(forKey key: String, value: Any) {
        let mirror = Mirror(reflecting: self)
        if let child = mirror.children.first(where: { $0.label == key }) {
            _ = child
        }
        let obj = self as AnyObject
        obj.setValue(value, forKey: key)
    }
}
