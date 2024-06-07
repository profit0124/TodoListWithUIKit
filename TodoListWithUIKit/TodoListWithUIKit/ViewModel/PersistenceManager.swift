//
//  PersistenceManager.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/7/24.
//

import Foundation
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoListWithUIKit")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("\(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
