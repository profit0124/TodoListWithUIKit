//
//  TodosViewModel.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/6/24.
//

import UIKit
import CoreData

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
        fetchTodos()
    }
    
    func fetchTodos() {
        let request = Todo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.deadline, ascending: false)]
        do {
            self.todos = try PersistenceManager.shared.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
        updateView()
    }
    
    func addTodo(_ todo: Todo) {
        fetchTodos()
    }
    
    func doneTodo(_ todo: Todo) {
        let todo = todo
        todo.isCompleted = true
        do {
            try PersistenceManager.shared.container.viewContext.save()
        } catch {
            print(error)
        }
        fetchTodos()
    }
    
    func updateTodo(_ todo: Todo) {
        fetchTodos()
    }
    
    func deleteTodo(_ todo: Todo) {
        PersistenceManager.shared.container.viewContext.delete(todo)
        fetchTodos()
    }
    
    func updateView() {
        let temp = NSDiffableDataSourceSnapshot<CollectionViewSection, Todo>()
        self.dataSource.apply(temp, animatingDifferences: false)
        
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
        self.addTodo(todo)
    }
    
    func updateAction(_ todo: Todo) {
        self.updateTodo(todo)
    }
}
