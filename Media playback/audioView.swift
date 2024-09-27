import SwiftUI
import AVFoundation


struct AudioSelectionView: View {
    @ObservedObject var audioManager: AudioManager
    @Environment(\.presentationMode) var presentationMode
    @State private var seekPos: Double = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.audio
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // List of songs
                    List {
                        ForEach(0..<audioManager.songs.count, id: \.self) { index in
                            Button(action: {
                                audioManager.playSong(index: index)
                            }) {
                                HStack {
                                    Text("Song \(index + 1)")
                                    Spacer()
                                    if audioManager.isPlaying && audioManager.currentSongIndex == index {
                                        Image(systemName: "play.fill")
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Select Audio")
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    
                    // Playback controls
                    HStack {
                        // Start Over Button
                        Button(action: {
                            audioManager.startOver()
                        }) {
                            Image(systemName: "gobackward")
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                        }
                        .padding()

                        // Play/Pause Button
                        Button(action: {
                            if audioManager.isPlaying {
                                audioManager.pausePlaying()
                            } else {
                                audioManager.resumePlaying()
                            }
                        }) {
                            Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                        }
                        .padding()
                    }
                    
                    // Duration Display
                    HStack {
                        Text(formatTime(audioManager.currentPlaybackTime))
                            .foregroundColor(.white)
                        Spacer()
                        if let duration = audioManager.currentSongDuration {
                            Text(formatTime(duration))
                                .foregroundColor(.white)
                        } else {
                            Text("00:00")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    // Slider for seeking
                    Slider(value: $seekPos, in: 0...1, onEditingChanged: { editing in
                        if !editing {
                            guard let duration = audioManager.currentSongDuration else { return }
                            let targetTime = seekPos * duration
                            audioManager.seekToTime(time: targetTime) // New function in AudioManager
                        }
                    })
                    .onReceive(audioManager.$seekPos) { pos in
                        self.seekPos = pos
                    }
                    .padding()
                }
            }

        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
                    audioManager.stopPlaying()
                }
    }
    
    // Helper function to format time
    private func formatTime(_ time: TimeInterval) -> String {
        // Check if time is a valid number
        guard time.isFinite && time >= 0 else {
            return "00:00" // Return default value if time is invalid
        }
        
        let minutes = Int(time) / 60 // Convert to Int for minutes
        let seconds = Int(time) % 60  // Seconds remains Int
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct AudioSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AudioSelectionView(audioManager: AudioManager())
    }
}
