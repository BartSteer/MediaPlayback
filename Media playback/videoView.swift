//
//  videoView.swift
//  Media playback
//
//  Created by Bart Steer on 24/09/2024.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var video: Video
    @State private var player = AVPlayer()
    @State private var isVideoEnded = false

    var body: some View {
        ZStack {
            // Use AVPlayerViewController for PiP functionality
            PlayerView(videoURL: URL(string: video.videoFiles.first?.link ?? "")!, player: $player, isVideoEnded: $isVideoEnded)
                .onAppear {
                    setupPlayer()
                }

            // Show rewind button when video ends
            if isVideoEnded {
                Button(action: {
                    rewindVideo()
                }) {
                    Image(systemName: "gobackward")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(50)
                        .opacity(0.9)
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2) // Center the button
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            print("VideoView is disappearing")
            player.pause()
            player.replaceCurrentItem(with: nil)
            deactivateAudioSession()
        }
    }
    
    // Setup player and observer for video end
    private func setupPlayer() {
        player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: video.videoFiles.first?.link ?? "")!))
        player.play()
        // Observe when the video finishes
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            isVideoEnded = true // Set the flag to show the rewind button
        }
    }

    private func rewindVideo() {
        player.seek(to: .zero) // Rewind to the start
        player.play() // Start playing the video again
        isVideoEnded = false // Hide the rewind button
    }
    
    private func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error deactivating audio session: \(error)")
        }
    }
}

struct PlayerView: UIViewControllerRepresentable {
    var videoURL: URL
    @Binding var player: AVPlayer // Use binding to access the player
    @Binding var isVideoEnded: Bool

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.allowsPictureInPicturePlayback = true // Enables PiP
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.showsPlaybackControls = !isVideoEnded
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: previewVideo) // Make sure `previewVideo` is defined appropriately
    }
}
