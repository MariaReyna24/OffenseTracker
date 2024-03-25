//
//  Haptics.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/21/24.
//

import Foundation
import SwiftUI
import CoreHaptics

fileprivate final class HapticsManager {
    static let shared = HapticsManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    private let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    private init() {}
    
    func triggerImpact() {
        impactFeedback.impactOccurred()
    }
    
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        feedback.notificationOccurred(notification)
    }
    
    func heavyHaptic() {
            HapticsManager.shared.triggerImpact()
    }
}
