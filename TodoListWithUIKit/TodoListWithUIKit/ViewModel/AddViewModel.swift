//
//  AddViewModel.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/6/24.
//

import Foundation

enum AddMode: String {
    case add = "Add"
    case update = "Update"
}

final class AddViewModel {
    var addMode: AddMode
    var todo: Todo
    
    weak var delegate: AddDelegate?
    
    init(todo: Todo? = nil, delegate: AddDelegate) {
        if let todo {
            self.addMode = .update
            self.todo = todo
        } else {
            self.addMode = .add
            self.todo = Todo(context: PersistenceManager.shared.container.viewContext)
            self.todo.id = UUID().uuidString
            self.todo.title = ""
            self.todo.deadline = Date()
            self.todo.isCompleted = false
        }
        self.delegate = delegate
    }
    
    func buttonAction() {
        do {
            try PersistenceManager.shared.container.viewContext.save()
        } catch {
            print(error)
        }
        
        switch addMode {
        case .add:
            self.delegate?.addAction(todo)
        case .update:
            self.delegate?.updateAction(todo)
        }
        
        
    }
}
