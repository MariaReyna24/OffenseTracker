//
//  Reaction.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 5/21/24.
//

import Foundation

struct Reactions: Identifiable {
    let id = UUID()
    let emoji: String
    var count: Int
    init(emoji: String, count: Int) {
        self.count = count
        self.emoji = emoji
    }
}
