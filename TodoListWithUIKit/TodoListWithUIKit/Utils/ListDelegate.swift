//
//  CustomDelegate.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/6/24.
//

import Foundation

protocol ListDelegate: AnyObject {
    func doneAction(_ todo: Todo)
    func deleteAction(_ todo: Todo)
}
