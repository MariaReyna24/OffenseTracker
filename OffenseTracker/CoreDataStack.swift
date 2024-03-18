//
//  CoreDataStack.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/18/24.
//

import Foundation
import CoreData

struct CoreDataStack {
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    static var preview: CoreDataStack = {
        let controller = CoreDataStack(inMemory: true)
        
        for _ in 0..<10 {
            let offense = Offense(context: controller.container.viewContext)
        }
        return controller
    }()
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}
