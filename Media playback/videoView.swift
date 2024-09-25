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
    @State private var isMuted: Bool = false

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
            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                            .onTapGesture {
                                isMuted.toggle() // Toggle mute state
                                player.isMuted = isMuted // Update player's mute state
                            }
                    }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: previewVideo)
    }
}
