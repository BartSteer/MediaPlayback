//
//  playerController.swift
//  Media playback
//
//  Created by Bart Steer on 17/09/2024.
//

import Foundation
import AVKit
import UIKit // For UIImage

class PlayerController: ObservableObject {
    // MARK: - Published Properties
    @Published var playbackVideoLink: String = ""
    @Published var playbackTitle: String = ""
    @Published var playbackArtist: String = ""
    @Published var playbackArtwork: String = ""

    // MARK: - AVPlayer and AVPlayerViewController Properties
    var player: AVPlayer?
    var avPlayerViewController: AVPlayerViewController = AVPlayerViewController()

    // MARK: - Initialization and Setup
    func initPlayer(
        title: String,
        link: String,
        artist: String,
        artwork: String
    ) {
        // Initialize playback properties
        self.playbackTitle = title
        self.playbackArtist = artist
        self.playbackArtwork = artwork
        self.playbackVideoLink = link

        // Setup AVPlayer and AVPlayerViewController
        setupPlayer()
        setupAVPlayerViewController()
    }

    // MARK: - AVPlayer Setup
    private func setupPlayer() {
        // Initialize AVPlayer with the provided video link
        guard let videoURL = URL(string: playbackVideoLink) else {
            print("Invalid video URL")
            return
        }
        player = AVPlayer(url: videoURL)
        //continue playing when closing the app
        player?.automaticallyWaitsToMinimizeStalling = false
        // Set up metadata for the current item
        setupMetadata()
    }

    // Set up metadata for the current AVPlayerItem
    private func setupMetadata() {
        let title = AVMutableMetadataItem()
        title.identifier = .commonIdentifierTitle
        title.value = playbackTitle as NSString
        title.extendedLanguageTag = "und"

        let artist = AVMutableMetadataItem()
        artist.identifier = .commonIdentifierArtist
        artist.value = playbackArtist as NSString
        artist.extendedLanguageTag = "und"

        let artwork = AVMutableMetadataItem()
        setupArtworkMetadata(artwork)

        // Set external metadata for the current AVPlayerItem
        player?.currentItem?.externalMetadata = [title, artist, artwork]
    }

    // Set up artwork metadata based on UIImage
    private func setupArtworkMetadata(_ artwork: AVMutableMetadataItem) {
        if let image = UIImage(named: playbackArtwork) {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                artwork.identifier = .commonIdentifierArtwork
                artwork.value = imageData as NSData
                artwork.dataType = kCMMetadataBaseDataType_JPEG as String
                artwork.extendedLanguageTag = "und"
            }
        } else {
            print("Artwork image not found")
        }
    }

    // MARK: - AVPlayerViewController Setup
    private func setupAVPlayerViewController() {
        // Assign AVPlayer to AVPlayerViewController
        avPlayerViewController.player = player
        avPlayerViewController.allowsPictureInPicturePlayback = true
        avPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = true
    }

    // MARK: - Playback Control
    func pausePlayer() {
        player?.pause()
    }

    func playPlayer() {
        player?.play()
    }
}

