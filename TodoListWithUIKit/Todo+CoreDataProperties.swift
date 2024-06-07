//
//  Todo+CoreDataProperties.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/7/24.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var deadline: Date?
    @NSManaged public var id: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
    
    public var unwrappedTitle: String {
        title ?? ""
    }
    
    public var unwrappedDeadline: Date {
        deadline ?? Date()
    }

}

extension Todo : Identifiable {

}
