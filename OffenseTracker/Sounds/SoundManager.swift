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
    
    enum Sounds: String, CaseIterable {
        case sus
        case angels
        case bam
    }
    
    func playSound(sound: Sounds) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }

}


