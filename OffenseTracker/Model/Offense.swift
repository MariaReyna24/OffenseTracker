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
    // to have this sync with the iCloud you need to only make the vars you want
    // to be saved in the iCloud
    var name: String?
    var date: Date?
    
    init(name: String = "", date: Date = Date.now) {
        self.name = name
        self.date = date
    }

}
