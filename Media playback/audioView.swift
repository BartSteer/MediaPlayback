//
//  audioView.swift
//  Media playback
//
//  Created by Bart Steer on 26/09/2024.
//

import SwiftUI

struct AudioSelectionView: View {
    @ObservedObject var audioManager: AudioManager // Reference to the audio player manager

    var body: some View {
        NavigationView {
            List {
                ForEach(0..<audioManager.songs.count, id: \.self) { index in
                    Button(action: {
                        audioManager.playSong(index: index) // Play the selected song
                    }) {
                        Text("Song \(index + 1)") // You can customize the song names here
                    }
                }
            }
            .navigationTitle("Select Audio")
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the selection view (optional)
            })
        }
    }
}

struct AudioSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AudioSelectionView(audioManager: AudioManager())
    }
}
