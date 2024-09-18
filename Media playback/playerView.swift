//
//  playerView.swift
//  Media playback
//
//  Created by Bart Steer on 17/09/2024.
//

import Foundation
import SwiftUI
import AVKit // Import AVKit for VideoPlayer

// A SwiftUI view representing the player interface
struct PlayerView: View {
    // StateObject that manages the player controller and its state
    @StateObject var playerController = PlayerController()

    var body: some View {
        VStack(alignment: .center) {
            // Use GeometryReader to adapt to the available space
            GeometryReader { geometry in
                let parentWidth = geometry.size.width

                // Display loading message if the player is not initialized yet
                if playerController.player == nil {
                    Text("Loading")
                } else {
                    // Use AVKit's VideoPlayer for video playback
                    VideoPlayer(player: playerController.player)
                        .frame(width: parentWidth)
                }
            }
            .frame(height: 200)

            // Play and Pause buttons
            Button {
                playerController.playPlayer()
            } label: {
                Text("Play video")
            }

            Button {
                playerController.pausePlayer()
            } label: {
                Text("Pause video")
            }
        }
        // Initialize the player on view appear
        .onAppear {
            playerController.initPlayer(
                title: "SomeTitle",
                link: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                artist: "Khondakar Afridi",
                artwork: "Artist"
            )
        }
    }
}

// Preview for PlayerView
#if DEBUG
struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
#endif
