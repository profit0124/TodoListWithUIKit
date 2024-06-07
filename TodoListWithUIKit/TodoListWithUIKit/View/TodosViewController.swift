//
//  ViewController.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/4/24.
//

import UIKit

class TodosViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .zero
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(TodoCellViewCollectionViewCell.self, forCellWithReuseIdentifier: TodoCellViewCollectionViewCell.id)
        return view
    } ()
    
    private var vm: TodosViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonAction))
        self.vm = .init(self.collectionView)
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 150)
        collectionView.collectionViewLayout = layout
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        self.navigationController?.navigationBar.topItem?.title = "Todo List"
        
    }
    
    func presentAddViewController(_ item: Todo? = nil) {
        let addVM = AddViewModel(todo: item, delegate: vm)
        let vc = UINavigationController(rootViewController: AddTodoViewViewController(vm: addVM))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    @objc private func addButtonAction() {
        presentAddViewController()
    }
}

extension TodosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = vm.dataSource.itemIdentifier(for: indexPath) else { return }
        self.presentAddViewController(item)
    }
}
