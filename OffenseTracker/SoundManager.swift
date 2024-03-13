//
//  SoundManager.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 3/12/24.
//
import SwiftUI
import AVFoundation

class SoundManager: ObservableObject {
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "sus", withExtension: ".mp3") else{return}
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound. \(error.localizedDescription)")
        }
        
    }
}

