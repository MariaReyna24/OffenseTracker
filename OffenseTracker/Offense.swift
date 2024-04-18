//
//  Offense.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import Foundation
import CloudKit

struct SingleOffense: Identifiable {
    var id: String
    var name: String
    var date: Date
    
    init(id: String = UUID().uuidString, name: String, date: Date) {
        self.id = id
        self.name = name
        self.date = date
    }
    static var exampleOff = [SingleOffense(name: "Burnt my shake", date: Date.now), SingleOffense(name: "Another 1", date: Date.now)]
}

@MainActor
class Offenses: ObservableObject{
    
    enum AppState {
        case loading, loaded, failed(Error)
    }
    private let ckService = CloudKitService()
    
    @Published var appState: AppState = .loaded
    @Published var listOfOffenses: [SingleOffense] = []
   
   
    func fetchOffenses() async throws {
        appState = .loading
        do {
            self.listOfOffenses = try await ckService.fetchEvents()
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }
    
    func saveNewEvent(withName name: String, date: Date) async throws {
        appState = .loading
        do {
            let off = SingleOffense(name: name, date: date)
            try await ckService.saveOff(off)
            listOfOffenses.append(off)
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }
    
    func delete(_ offToRemove: SingleOffense) async throws {
        appState = .loading
        do {
            try await ckService.delteEvent(offToRemove)
            listOfOffenses = listOfOffenses.filter { storedOff in
                return storedOff.id != offToRemove.id
            }
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }
    
    func update(_ updateOff: SingleOffense) async throws {
        appState = .loading
        do {
            try await ckService.updateOffense(updateOff)
            var updatedOffs = listOfOffenses.filter { storedOff in
                return storedOff.id != updateOff.id
            }
            updatedOffs.append(updateOff)
            self.listOfOffenses = updatedOffs
            appState = .loaded
            
        } catch {
            appState = .failed(error)
        }
    }
}
