//
//  ContentView.swift
//  Media playback
//
//  Created by Bart Steer on 10/09/2024.
//

import SwiftUI
import AVKit
import AVFoundation

struct ContentView: View {
   
    var body: some View {
            PlayerView()
        }
    
    /*
    // The URL for the video
    let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
    
    // Create an instance of AVPlayer
    @State private var player = AVPlayer()
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(red: 0.2, green: 0.2, blue: 0.3)
                    .ignoresSafeArea()
            VStack {
                VideoPlayer(player: player)
                    .frame(height: 300)
                    .onAppear {
                        setupBackgroundAudio{
                            player = AVPlayer(url: url)
                            
                            //notification observer for interruptions (not working)
                            NotificationCenter.default.addObserver(
                            forName: AVAudioSession.interruptionNotification,
                                object: nil,
                                queue: nil,
                                using: handleAudioInterruption(notification:)
                            )
                        }
                    }
            }
            
            .padding()
            }
        }
    }
    
    func setupBackgroundAudio(completion: @escaping () -> Void) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session: \(error.localizedDescription)")
        }
        completion()
    }
    
    /*func setupBackgroundAudio(completion: @escaping () -> Void) {
            DispatchQueue.global(qos: .background).async {
                do {
                    // Set the audio session category for background playback
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
                    try AVAudioSession.sharedInstance().setActive(true)
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Failed to set up audio session for background playback: \(error)")
                }
            }
        }*/
    
    
    /*func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let interruptionType = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        
        if interruptionType == AVAudioSession.InterruptionType.began.rawValue {
            // Pause playback if necessary
            player.pause()
        } else if interruptionType == AVAudioSession.InterruptionType.ended.rawValue {
            // Resume playback after interruption ends
            player.play()
        }
    }*/
    
    func handleAudioInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        if type == .began {
            // Audio was interrupted (e.g., another app started audio)
            print("Audio interrupted: pausing secondary audio.")
            // Handle audio interruption, such as pausing audio playback
        } else if type == .ended {
            // Audio interruption ended, you can now restart your audio
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            
            if options.contains(.shouldResume) {
                print("Audio interruption ended: resuming secondary audio.")
                // Handle resuming audio playback
            }
        }
    }*/
}

#Preview {
    ContentView()
}
