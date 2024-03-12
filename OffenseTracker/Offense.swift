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
    var name: String
    var date: Date
    init(name: String = "", date: Date = Date.now) {
        self.name = name
        self.date = date
    }
    
}




