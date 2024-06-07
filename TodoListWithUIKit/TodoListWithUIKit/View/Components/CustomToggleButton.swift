//
//  CustomToggleButton.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/6/24.
//

import UIKit

class CustomToggleButton: UIButton {
    var isCompleted: Bool = false {
        didSet {
            if isCompleted {
                self.centerLayer.backgroundColor = UIColor.gray.cgColor
            } else {
                self.centerLayer.backgroundColor = UIColor.clear.cgColor
            }
        }
    }
    
    let centerLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.gray.cgColor
        
        layer.addSublayer(centerLayer)
//        self.addTarget(self, action: #selector(done), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
        centerLayer.frame = CGRect(x: 3, y: 3, width: frame.width - 6, height: frame.height - 6)
        centerLayer.cornerRadius = (frame.width - 6) / 2
        centerLayer.backgroundColor = isCompleted ? UIColor.gray.cgColor : UIColor.clear.cgColor
    }
    
    @objc private func buttonAction() {
        self.isCompleted.toggle()
    }
}


