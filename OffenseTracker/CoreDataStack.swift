//
//  CoreDataStack.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/18/24.
//

import Foundation
import CoreData
import CloudKit

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
     var persistentContainer: NSPersistentCloudKitContainer = {
      
          let container = NSPersistentCloudKitContainer(name: "Model")
          container.loadPersistentStores(completionHandler: {
              (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
        
          return container
      }()
    //var container = CKDatabase.
    var publicDatabase = container.publicCloudDatabase
    static var preview: CoreDataStack = {
        let controller = CoreDataStack(inMemory: true)
        
        for _ in 0..<10 {
            let offense = Offense(context: controller.persistentContainer.viewContext)
        }
        return controller
    }()
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentCloudKitContainer(name: "Model")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
   
}
