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
    
    var body: some View {
        ZStack {
            // Use AVPlayerViewController for PiP functionality
            PlayerView(videoURL: URL(string: video.videoFiles.first?.link ?? "")!)
        }
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            print("VideoView is disappearing")
            player.pause()
            player.replaceCurrentItem(with: nil)
            do {
                   try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
               } catch {
                   print("Error deactivating audio session: \(error)")
               }
        }
    }
}
    struct PlayerView: UIViewControllerRepresentable {
        var videoURL: URL
        
        func makeUIViewController(context: Context) -> AVPlayerViewController {
            let controller = AVPlayerViewController()
            let player = AVPlayer(url: videoURL)
            controller.player = player
            controller.player?.play() // Start playing the video
            controller.allowsPictureInPicturePlayback = true // Enables PiP
            return controller
        }
        
        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
            // No updates needed
        }
    }
    
    struct VideoView_Previews: PreviewProvider {
        static var previews: some View {
            VideoView(video: previewVideo) // Make sure `previewVideo` is defined appropriately
        }
    }

/*struct VideoView: View {
    var video: Video
    @State private var player = AVPlayer()

    var body: some View {
        ZStack(alignment: .topTrailing){
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                if let link = video.videoFiles.first?.link {
                    player = AVPlayer(url: URL(string: link)!)
                    player.play()
                }
            }
            .onDisappear {
                player.replaceCurrentItem(with: nil)
            }
                    }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: previewVideo)
    }
}*/
