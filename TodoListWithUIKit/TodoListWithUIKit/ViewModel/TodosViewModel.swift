//
//  TodosViewModel.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/6/24.
//

import UIKit
import RxSwift
import CoreData

enum CollectionViewSection: CaseIterable {
    case main
}

final class TodosViewModel {
    var todos: BehaviorSubject<[Todo]> = BehaviorSubject<[Todo]>(value: [])
    private let disposeBag = DisposeBag()
    
    var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, Todo>!
    
    init(_ collectionView: UICollectionView) {
        self.dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, todo) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCellViewCollectionViewCell.id, for: indexPath) as? TodoCellViewCollectionViewCell else { return UICollectionViewCell() }
            cell.configuration(todo: todo, delegate: self)
            return cell
        }
        bind()
        fetchTodos()
    }
    
    func bind() {
        todos.asObservable()
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                var snapShot = NSDiffableDataSourceSnapshot<CollectionViewSection, Todo>()
                self.dataSource.apply(snapShot, animatingDifferences: true)
                snapShot.appendSections([.main])
                snapShot.appendItems(items.filter({ !$0.isCompleted }))
                self.dataSource.apply(snapShot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchTodos() {
        let request = Todo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.deadline, ascending: false)]
        do {
            let todoItems = try PersistenceManager.shared.container.viewContext.fetch(request)
            self.todos.onNext(todoItems)
        } catch {
            print(error)
        }
    }
    
    func addTodo(_ todo: Todo) {
        do {
            var values = try todos.value()
            values.append(todo)
            self.todos.onNext(values)
        } catch {
            print(error)
        }
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
    
//    func updateView() {
//        let temp = NSDiffableDataSourceSnapshot<CollectionViewSection, Todo>()
//        self.dataSource.apply(temp, animatingDifferences: false)
//        
//        let filtered = self.todos.filter({ !$0.isCompleted })
//        var snapshopt = NSDiffableDataSourceSnapshot<CollectionViewSection, Todo>()
//        snapshopt.appendSections([.main])
//        snapshopt.appendItems(filtered)
//        self.dataSource.apply(snapshopt, animatingDifferences: true)
//    }
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
