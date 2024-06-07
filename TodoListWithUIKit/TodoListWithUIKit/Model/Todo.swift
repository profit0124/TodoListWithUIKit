//
//  Todo.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/4/24.
//

import Foundation

struct Todo: Identifiable, Equatable, Hashable {
    
    let id: String
    var title: String
    var deadLine: Date
    var isCompleted: Bool
    
    init(id: String, title: String, deadLine: Date, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.deadLine = deadLine
        self.isCompleted = isCompleted
    }
}
