//
//  OffenseTrackerApp.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI
import CloudKit
import CoreData

@main
struct OffenseTrackerApp: App {
    @Environment(\.scenePhase) var scenePhase
    var persistenceController = CoreDataStack.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
        }
    }
}
