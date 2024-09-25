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
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationView {
            VStack {
                //fix
                TextField("Search", text: $videoManager.customQuery)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal, 20)
                                    .padding(.top, 5)
                                    .onSubmit {
                                        // Fetch videos based on the custom query when the user submits
                                        if !videoManager.customQuery.isEmpty {
                                            Task {
                                                await videoManager.findVideos(topic: videoManager.customQuery)
                                            }
                                        }
                                    }
                
                
                
                HStack {
                    ForEach(Query.allCases, id: \.self) { searchQuery in
                        QueryTag(query: searchQuery, isSelected: videoManager.selectedQuery == searchQuery)
                            .onTapGesture {
                                // When the user taps on a QueryTag, we'll change the selectedQuery from VideoManager
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
