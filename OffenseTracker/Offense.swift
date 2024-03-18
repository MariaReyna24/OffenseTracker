//
//  Offense.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import Foundation
import CloudKit



class Offenses: ObservableObject {
    @Published var name: String
    @Published var date: Date
   
    init(name: String = "", date: Date) {
        self.name = name
        self.date = date
    }
}
