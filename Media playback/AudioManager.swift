import Foundation
import AVFoundation
import MediaPlayer
import Combine

class AudioManager: ObservableObject {
    var player: AVPlayer?
    @Published var isPlaying: Bool = false
    @Published var currentSongIndex: Int? = nil // Track the currently playing song
    @Published var currentPlaybackTime: TimeInterval = 0.0 // Track current playback time
    @Published var currentSongDuration: TimeInterval? // Track current song duration
    @Published var seekPos: Double = 0.0

    // Sample audio URLs
    let songs = [
        URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!,
        URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")!
    ]
    
    // Sample metadata for songs
    let songTitles = [
        "SoundHelix Song 1",
        "SoundHelix Song 2"
    ]

    private var timeObserverToken: Any?

    init() {
        // Initialize player and add periodic time observer
               player = AVPlayer()

               // Add the periodic time observer to update seekPos
               player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
                   guard let currentItem = self?.player?.currentItem else {
                       return
                   }
                   // Update seek position
                   if currentItem.duration.seconds > 0 {
                       self?.seekPos = time.seconds / currentItem.duration.seconds
                   }
               }
        // Register for audio interruptions
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    deinit {
        // Clean up the observer
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
        }
    }

    // Function to seek to a specific time
        func seekToTime(time: Double) {
            let targetTime = CMTime(seconds: time, preferredTimescale: 600)
            player?.seek(to: targetTime)
        }
    
    // Play a song by its index
    func playSong(index: Int) {
        guard index < songs.count else { return }
        
        // If there's already a song playing, pause it before switching
        if let currentIndex = currentSongIndex, currentIndex != index {
            player?.pause() // Pause the currently playing song
        }

        // Update the current song index
        currentSongIndex = index
        
        // Create a new player for the selected song
        let url = songs[index]
        player = AVPlayer(url: url)
        
        // Add periodic time observer to update playback time and duration
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self, let item = self.player?.currentItem else { return }
            self.currentPlaybackTime = time.seconds
            self.currentSongDuration = item.duration.seconds
        }

        // Play the new song
        player?.play()
        isPlaying = true
        currentPlaybackTime = 0.0 // Reset playback time
    }


    // Stop audio playback
    func stopPlaying() {
        player?.pause()
        isPlaying = false
        currentSongIndex = nil // Reset the current song index when stopped
        currentPlaybackTime = 0.0 // Reset playback time
        currentSongDuration = nil // Reset song duration
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    // Pause audio playback
    func pausePlaying() {
        player?.pause()
        isPlaying = false
    }

    // Resume audio playback
    func resumePlaying() {
        player?.play()
        isPlaying = true
    }
    
    // Start Over
    func startOver() {
        player?.seek(to: .zero)
        player?.play()
        isPlaying = true
    }

    // Seek to a specific time in the song
    func seek(to time: TimeInterval) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 600))
    }
    

    // Handle audio session interruptions (e.g., incoming call, alarm)
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let interruptionTypeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeValue) else {
            return
        }

        switch interruptionType {
        case .began:
            // Interruption began, pause the player
            player?.pause()
            isPlaying = false
            print("Audio interrupted. Playback paused.")

        case .ended:
            // Interruption ended, resume playback if needed
            if let interruptionOptions = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt,
               AVAudioSession.InterruptionOptions(rawValue: interruptionOptions).contains(.shouldResume) {
                player?.play()
                isPlaying = true
                print("Interruption ended. Resuming playback.")
            }

        @unknown default:
            break
        }
    }
}
