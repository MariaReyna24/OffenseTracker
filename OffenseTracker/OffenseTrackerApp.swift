//
//  OffenseTrackerApp.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import SwiftUI
import SwiftData
import CloudKit
@main
struct OffenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            //The modelContainer creates a Container for your data that stores that data and persists it
        }.modelContainer(for: Offenses.self)
    }
}
