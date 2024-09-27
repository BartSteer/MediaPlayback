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
    @StateObject var videoManager = VideoManager()
    @StateObject var audioManager = AudioManager() // Add audio player manager
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $videoManager.customQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                        .onSubmit {
                            if !videoManager.customQuery.isEmpty {
                                Task {
                                    await videoManager.findVideos(topic: videoManager.customQuery)
                                }
                            }
                        }
                    
                    // Navigation link for the speaker icon
                                      NavigationLink(destination: AudioSelectionView(audioManager: audioManager)) {
                                          Image(systemName: "headphones") // Use the filled speaker icon
                                              .resizable()
                                              .frame(width: 30, height: 30)
                                              .padding(.trailing, 20)
                                              .foregroundColor(.white)
                                      }
                                  }

                HStack {
                    ForEach(Query.allCases, id: \.self) { searchQuery in
                        QueryTag(query: searchQuery, isSelected: videoManager.selectedQuery == searchQuery)
                            .onTapGesture {
                                videoManager.selectedQuery = searchQuery
                            }
                    }
                }
                
                ScrollView {
                    if videoManager.videos.isEmpty {
                        ProgressView()
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(videoManager.videos, id: \.id) { video in
                                NavigationLink {
                                    VideoView(video: video)
                                } label: {
                                    VideoCard(video: video)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color("AccentColor"))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
