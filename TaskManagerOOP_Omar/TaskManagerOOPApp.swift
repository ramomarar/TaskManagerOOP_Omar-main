import SwiftUI

@main
struct TaskManagerOOPApp: App {
    @StateObject private var store = TaskStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
