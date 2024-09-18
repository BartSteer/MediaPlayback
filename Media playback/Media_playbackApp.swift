//
//  Media_playbackApp.swift
//  Media playback
//
//  Created by Bart Steer on 10/09/2024.
//

import SwiftUI
import AVFoundation

@main
struct Media_playbackApp: App {
    // Add the AppDelegate adaptor
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
        var body: some Scene {
            WindowGroup {
                ContentView()  // This remains the same
            }
        }
    }

    // Custom AppDelegate to handle application lifecycle events
    class AppDelegate: NSObject, UIApplicationDelegate {
        
        // This method is called when the application finishes launching
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            // Configure the audio session for background audio and video services
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                // Set the audio session category to playback
                try audioSession.setCategory(.playback)
                
                // Activate the audio session
                try audioSession.setActive(true, options: [])
            } catch {
                // Handle errors related to audio session setup
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            
            return true
        }
}
