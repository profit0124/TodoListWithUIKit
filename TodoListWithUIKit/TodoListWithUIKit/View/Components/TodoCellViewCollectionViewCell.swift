//
//  TodoCellViewCollectionViewCell.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/4/24.
//

import UIKit
import PinLayout
import FlexLayout

class TodoCellViewCollectionViewCell: UICollectionViewCell {
    static let id = "CollectionViewCell"
    
    let flexContainerView: UIView = UIView()
    
    weak var delegate: ListDelegate?
    
    var todo: Todo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 9
        addSubview(flexContainerView)
        
        flexContainerView.flex.padding(16).direction(.column).justifyContent(.spaceBetween).define({
            $0.addItem().direction(.row).justifyContent(.spaceBetween).define({
                $0.addItem(titleView)
                $0.addItem(deleteButton).size(20)
            })
            
            $0.addItem().direction(.row).alignItems(.end).justifyContent(.spaceBetween).define({
                $0.addItem().direction(.column).grow(1).define({
                    $0.addItem(deadlineDateView)
                    $0.addItem(deadlineTimeView)
                })
                
                $0.addItem(doneButton).size(20)
            })
            
            
        })
        self.doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(deleteTodo), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        self.flexContainerView.pin.all()
        self.flexContainerView.flex.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    } ()
    
    lazy var deadlineDateView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    } ()
    
    lazy var deadlineTimeView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    } ()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "trash.square"), for: .normal)
        return button
    } ()
    
    private let doneButton: CustomToggleButton = CustomToggleButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    func configuration(todo: Todo, delegate: ListDelegate) {
        titleView.text = todo.title
        deadlineDateView.text = todo.deadLine.changeToString()
        deadlineTimeView.text = todo.deadLine.formatted(date: .omitted, time: .shortened)
        self.todo = todo
        self.delegate = delegate
        layoutIfNeeded()
    }
}

// MARK: Button Action
extension TodoCellViewCollectionViewCell {
    
    @objc private func done() {
        if let todo {
            doneButton.isCompleted.toggle()
            delegate?.doneAction(todo)
        }
    }
    
    @objc private func deleteTodo() {
        if let todo {
            delegate?.deleteAction(todo)
        }
    }
}
