//
//  Offense.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import Foundation

struct Offense: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
}
class OffenseViewModel: ObservableObject {
    @Published var offenses = [Offense]()
    let defaults = UserDefaults.standard
    func addOffense(name: String) {
        let offense = Offense(name: name)
        offenses.append(offense)
    }
    func saveOffenses() {
        let data = try? JSONEncoder().encode(offenses)
        UserDefaults.standard.set(data, forKey: "Offenses")
    }
    
    func loadOffenses() {
        if let data = UserDefaults.standard.data(forKey: "Offenses"),
           let savedOffenses = try? JSONDecoder().decode([Offense].self, from: data) {
            offenses = savedOffenses
        }
    }
}


