//
//  Offense.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import Foundation
import SwiftData

@Model
class Offenses {
    @Attribute(.unique) var name: String
    @Attribute(.unique) var date: Date
    init(name: String = "", date: Date = Date.now) {
        self.name = name
        self.date = date
    }
    
}
