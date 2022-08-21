//
//  PreviewMocks.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import MusicKit

public struct MockData {
    public static let playlist = PreviewPlaylist(name: "Test", items: [], cloudGlobalID: "", representativeItem: nil)
    public static let track = PreviewTrack(name: "Test", artist: "Test", playbackStoreID: "", isExplicitItem: true)
}

public struct PreviewPlaylist: Playlist {
    public var name: String?
    public var items: [MPMediaItem]
    public var cloudGlobalID: String?
    public var representativeItem: MPMediaItem?
}

public struct PreviewTrack: Track {
    public var name: String?
    public var artist: String?
    public var musicKitArtwork: MusicKit.Artwork?
    public var mpArtwork: MPMediaItemArtwork?
    public var playbackStoreID: String
    public var isExplicitItem: Bool
    
    public func getBlockedTrack() -> BlockedTrack {
        return BlockedTrack(title: self.name,
                            artist: self.artist,
                            isExplicit: self.isExplicitItem,
                            playbackID: self.playbackStoreID)
    }
}
