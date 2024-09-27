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
               configureAudioSession()
               return true
           }
           
           private func configureAudioSession() {
               let audioSession = AVAudioSession.sharedInstance()
               
               do {
                   // Set the audio session category, mode, and options
                   try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                   print("Audio session category set.")
                   
                   // Activate the audio session
                   try audioSession.setActive(true)
                   print("Audio Session is Active")
                   
               } catch {
                   print("Error setting up audio session: \(error)")
               }
           }
        

        
        // Handle audio session interruptions
            @objc func handleInterruption(notification: Notification) {
                guard let userInfo = notification.userInfo,
                      let interruptionTypeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeValue) else {
                    return
                }
                
                switch interruptionType {
                case .began:
                    // Pause playback when an interruption begins (e.g., phone call)
                    NotificationCenter.default.post(name: NSNotification.Name("PauseAudioPlayback"), object: nil)
                    print("Audio session interrupted. Pausing playback.")
                
                case .ended:
                    // Check if the interruption ends and decide whether to resume
                    if let interruptionOptionValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                        let interruptionOptions = AVAudioSession.InterruptionOptions(rawValue: interruptionOptionValue)
                        
                        if interruptionOptions.contains(.shouldResume) {
                            // Automatically resume playback if the interruption allows
                            NotificationCenter.default.post(name: NSNotification.Name("ResumeAudioPlayback"), object: nil)
                            print("Interruption ended. Resuming playback.")
                        }
                    }
                @unknown default:
                    break
                }
            }
            
            deinit {
                // Remove observer when the app is deallocated
                NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
            }
    }
    
