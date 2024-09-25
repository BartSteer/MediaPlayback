//
//  VideoManager.swift
//  Media playback
//
//  Created by Bart Steer on 18/09/2024.
//

import Foundation

enum Query: String, CaseIterable {
    case nature, animals, people, ocean, food
}

class VideoManager: ObservableObject {
    
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.nature {
        didSet {
            Task.init {
                await findVideos(topic: selectedQuery.rawValue)
            }
        }
    }
    
    @Published var customQuery: String = "" { // Property for custom queries
           didSet {
               Task.init {
                   await findVideos(topic: customQuery) // Call findVideos with custom query
               }
           }
       }
    
    // On initialize of the class, fetch the videos
    init() {
        // Need to Task.init and await keyword because findVideos is an asynchronous function
        Task.init {
            await findVideos(topic: selectedQuery.rawValue)
        }
    }
    
    // Fetching the videos asynchronously
    func findVideos(topic: String) async {
        guard !topic.isEmpty else {
            print("Search query is empty.")
            return
        }
        
        do {
            // Make sure we have a valid URL
            guard let url = URL(string: "https://api.pexels.com/videos/search?query=\(topic)&per_page=10&orientation=portrait") else {
                fatalError("Invalid URL for the given topic: \(topic)")
            }

            // Create a URLRequest
            var urlRequest = URLRequest(url: url)

            // Setting the Authorization header
            urlRequest.setValue("XbOsXkrvOOaAFOVzYp3M9TDBAIMlItCfOLdrqblHTKNrR9sCywyrXaGw", forHTTPHeaderField: "Authorization")

            // Fetching the data
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // Making sure the response is 200 OK before continuing
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error while fetching data: Status code is not 200")
            }

            // Decoding the response
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedData = try decoder.decode(ResponseBody.self, from: data)

            // Update the videos on the main thread
            DispatchQueue.main.async {
                self.videos = decodedData.videos
            }

        } catch {
            print("Error fetching data from Pexels: \(error)")
        }
    }}

struct ResponseBody: Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
    
}

struct Video: Identifiable, Decodable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Identifiable, Decodable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Identifiable, Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
