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
        }.modelContainer(for: Offenses.self)
    }
}
