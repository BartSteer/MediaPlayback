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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
      
      var body: some Scene {
        WindowGroup {
          ContentView()
        }
      }
    }

    // AppDelegate
    class AppDelegate: NSObject, UIApplicationDelegate {
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
          print("Playback OK")
          try AVAudioSession.sharedInstance().setActive(true)
          print("Session is Active")
        } catch {
          print(error)
        }
        return true
      }
    }
    
    /*
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
        
        var audioSession: AVAudioSession?

           func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

               // Move the audio session setup to a background thread to avoid blocking the main thread
               DispatchQueue.global(qos: .userInitiated).async {
                   self.setupAudioSession()
               }
               
               // Register observers (if they are not heavy operations)
               NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(handleAppWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

               return true
           }

           private func setupAudioSession() {
               // Configure the audio session for background audio and video services
               self.audioSession = AVAudioSession.sharedInstance()

               do {
                   // Set the audio session category to playback
                   try self.audioSession?.setCategory(.playback)

                   // Activate the audio session
                   try self.audioSession?.setActive(true, options: [])
               } catch {
                   // Handle errors related to audio session setup
                   print("Setting category to AVAudioSessionCategoryPlayback failed: \(error.localizedDescription)")
               }
           }

           @objc func handleAppDidEnterBackground() {
               print("App entered background")
           }

           @objc func handleAppWillEnterForeground() {
               print("App will enter foreground")
           }

           deinit {
               NotificationCenter.default.removeObserver(self)
           }
}
*/
