//
//  AudioManager.swift
//  Media playback
//
//  Created by Bart Steer on 26/09/2024.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    var player: AVPlayer?
    @Published var isPlaying: Bool = false

    // Sample audio URLs
    let songs = [
        URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!,
        URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")!
    ]

    func playSong(index: Int) {
        guard index < songs.count else { return }
        let url = songs[index]
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
        // Configure audio session for background playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }

    func stopPlaying() {
        player?.pause()
        isPlaying = false
    }
}
