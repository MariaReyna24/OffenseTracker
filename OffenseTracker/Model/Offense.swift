//
//  Offense.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import Foundation
import SwiftData
import CloudKit

// Model makes this class Observable and a data Model
@Model
class Offenses {
    
    enum AppState: Codable {
        case loading, loaded, failed
    }
    
   private let ckService = CloudKitService()
    
    var name: String?
    var date: Date?
    var appState: AppState = AppState.loaded
    
   
    
//    func fetchEvents() async throws {
//        appState = .loading
//        do {
//            self.name = try await ckService.fetchEvents()
//        }
//        
//    }
    
    // to have this sync with the iCloud you need to only make the vars you want
    // to be saved in the iCloud
  
    
    init(name: String = "", date: Date = Date.now, appState: AppState = AppState.loaded) {
        self.name = name
        self.date = date
        self.appState = appState
    }
    
}

