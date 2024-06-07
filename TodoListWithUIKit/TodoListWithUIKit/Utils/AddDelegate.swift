//
//  AddDelegate.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/7/24.
//

import Foundation


protocol AddDelegate: AnyObject {
    func addAction(_ todo: Todo)
    func updateAction(_ todo: Todo)
}
