//
//  Item.swift
//  TaskManagerOOP_Omar
//
//  Created by Omar Alkilani on 27/8/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
