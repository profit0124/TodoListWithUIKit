//
//  TodosViewModel.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/6/24.
//

import UIKit

enum CollectionViewSection: CaseIterable {
    case main
}

final class TodosViewModel {
    var todos: [Todo] = []
    
    var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, Todo>!
    
    init(_ collectionView: UICollectionView) {
        self.dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, todo) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCellViewCollectionViewCell.id, for: indexPath) as? TodoCellViewCollectionViewCell else { return UICollectionViewCell() }
            cell.configuration(todo: todo, delegate: self)
            return cell
        }
        updateView()
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        updateView()
    }
    
    func doneTodo(_ todo: Todo) {
        if let index = todos.firstIndex(of: todo) {
            var todo = todo
            todo.isCompleted = true
            todos[index] = todo
            updateView()
        }
    }
    
    func updateTodo(_ todo: Todo) {
        for index in 0..<todos.count {
            if todos[index].id == todo.id {
                todos[index] = todo
                updateView()
                break
            }
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        if let index = todos.firstIndex(of: todo) {
            todos.remove(at: index)
            updateView()
        }
    }
    
    func updateView() {
//        let temp = NSDiffableDataSourceSnapshot<CollectionViewSection, Todo>()
//        self.dataSource.apply(temp, animatingDifferences: true)
        let filtered = self.todos.filter({ !$0.isCompleted })
        var snapshopt = NSDiffableDataSourceSnapshot<CollectionViewSection, Todo>()
        snapshopt.appendSections([.main])
        snapshopt.appendItems(filtered)
        self.dataSource.apply(snapshopt, animatingDifferences: true)
    }
}


extension TodosViewModel: ListDelegate {
    func doneAction(_ todo: Todo) {
        self.doneTodo(todo)
    }
    
    func deleteAction(_ todo: Todo) {
        self.deleteTodo(todo)
    }
}

extension TodosViewModel: AddDelegate {
    func addAction(_ todo: Todo) {
        print("add Todo")
        self.addTodo(todo)
    }
    
    func updateAction(_ todo: Todo) {
        print("update Todo")
        self.updateTodo(todo)
    }
}
