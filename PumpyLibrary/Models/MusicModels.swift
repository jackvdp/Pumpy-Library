//
//  MusicModels.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/08/2022.
//

import Foundation
import MediaPlayer
import MusicKit

public protocol Track {
    var name: String? { get }
    var artist: String? { get }
    var musicKitArtwork: MusicKit.Artwork? { get }
    var mpArtwork: MPMediaItemArtwork? { get }
    var playbackStoreID: String { get }
    var isExplicitItem: Bool { get }
    
    func getBlockedTrack() -> BlockedTrack
}

public protocol Playlist {
    var name: String? { get }
    var items: [MPMediaItem] { get }
    var cloudGlobalID: String? { get }
    var representativeItem: MPMediaItem? { get }
}

public struct BlockedTrack: Codable, Hashable {
    public init(title: String? = nil, artist: String? = nil, isExplicit: Bool? = nil, playbackID: String) {
        self.title = title
        self.artist = artist
        self.isExplicit = isExplicit
        self.playbackID = playbackID
    }
    
    public var title: String?
    public var artist: String?
    public var isExplicit: Bool?
    public var playbackID: String
}

public enum PlayButton: String {
    case playing = "Pause"
    case notPlaying = "Play"
}


extension Song: PumpyLibrary.Track {

    public var name: String? {
        self.title
    }

    public var artist: String? {
        self.artistName
    }

    public var mpArtwork: MPMediaItemArtwork? {
        return nil
    }

    public var musicKitArtwork: MusicKit.Artwork? {
        return self.artwork
    }

    public var playbackStoreID: String {
        self.id.rawValue
    }

    public var isExplicitItem: Bool {
        self.contentRating == .explicit
    }

    public func getBlockedTrack() -> BlockedTrack {
        return BlockedTrack(title: self.title, artist: self.artist, isExplicit: isExplicitItem, playbackID: playbackStoreID)
    }


}
