//
//  DomainProtocols.swift
//  TaskManagerOOP_Omar
//
//  Created by Omar Alkilani on 27/8/2025.
//


import Foundation


/// Basic capability for toggling completion
protocol Completable {
var isCompleted: Bool { get set }
func toggleComplete()
}


/// Items that can be scheduled
protocol Schedulable {
var dueDate: Date? { get set }
}


/// Items that can be ranked in importance/urgency
protocol Prioritizable {
var priority: TaskPriority { get set }
}


/// Ensures we can serialize to a neutral representation for persistence
protocol DTOConvertible {
associatedtype DTO: Codable
func toDTO() -> DTO
}
