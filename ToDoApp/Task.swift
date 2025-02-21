//
//  Item.swift
//  ToDoApp
//
//  Created by Сергей Лукичев on 21.02.2025.
//

import Foundation
import SwiftData

@Model
final class Task: Hashable {
    var id: UUID
    var timestamp: Date
    var title: String
    
    init(title: String) {
        self.id = UUID()
        self.timestamp = Date()
        self.title = title
    }
    
    // Реализация Hashable
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id && lhs.timestamp == rhs.timestamp && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timestamp)
        hasher.combine(title)
    }
}
