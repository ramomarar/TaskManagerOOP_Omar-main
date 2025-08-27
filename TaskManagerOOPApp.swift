//
//  TaskManagerOOPApp.swift
//  TaskManagerOOPApp
//
//  Created by Omar Alkilani on 27/8/2025.
//

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
