//
//  AddTodoViewViewController.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/6/24.
//

import UIKit
import PinLayout
import FlexLayout

class AddTodoViewViewController: UIViewController {
    
    private var vm: AddViewModel!
    
    public init(vm: AddViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var containerView: UIView = UIView()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .black
        label.textAlignment = .left
        label.tag = 0
        return label
    } ()
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .none
        textField.textColor = .black
        return textField
    } ()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textColor = .black
        label.textAlignment = .left
        return label
    } ()
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .automatic
        picker.datePickerMode = .dateAndTime
        return picker
    } ()
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.black.cgColor
        button.clipsToBounds = true
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(containerView)
        
        titleTextField.delegate = self
        containerView.flex.padding(16).direction(.column).justifyContent(.spaceBetween).define({
            $0.addItem().direction(.column).top(32).define {
                $0.addItem().direction(.column).bottom(24).define({
                    $0.addItem(titleLabel).bottom(8)
                    $0.addItem(titleTextField)
                })
                
                $0.addItem().direction(.column).define({
                    $0.addItem(dateLabel)
                    $0.addItem(datePicker)
                })
            }
            
            $0.addItem(button).height(48)
        })
        self.button.setTitle(vm.addMode.rawValue, for: .normal)
        self.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.changeButtonStatus(!vm.todo.title.isEmpty)
        self.titleTextField.text = vm.todo.title
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissAction))
        self.datePicker.addTarget(self, action: #selector(changeDate(_ :)), for: .valueChanged)
        self.navigationController?.navigationBar.topItem?.title = "\(vm.addMode.rawValue) Todo"
    }
    
    override func viewDidLayoutSubviews() {
        self.containerView.pin.all(view.pin.safeArea)
        self.containerView.flex.layout()
        self.setBottomLyaer()
    }
    
    func setBottomLyaer() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.titleTextField.frame.height + 2, width: self.titleTextField.frame.width, height: 1)
        bottomLayer.backgroundColor = UIColor.black.cgColor
        self.titleTextField.layer.addSublayer(bottomLayer)
    }
    
    @objc private func dismissAction() {
        self.dismiss(animated: true)
    }
    
    func changeButtonStatus(_ isEnabled: Bool) {
        self.button.isEnabled = isEnabled
        self.button.layer.backgroundColor = isEnabled ? UIColor.black.cgColor : UIColor.gray.cgColor
    }
    
    @objc func buttonAction() {
        vm.buttonAction()
        self.dismiss(animated: true)
    }
    
    @objc func changeDate(_ sender: UIDatePicker) {
        vm.todo.deadLine = sender.date
    }
}

extension AddTodoViewViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 0 {
            if textField.text?.isEmpty ?? true {
                self.changeButtonStatus(false)
            } else {
                self.changeButtonStatus(true)
                self.vm.todo.title = textField.text ?? "nil"
            }
        }
    }
}
