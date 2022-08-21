//
//  PlaylistProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol PlaylistProtocol: ObservableObject {
    var playlistLabel: String { get set }
    var playlistURL: String { get set }
}

class MockPlaylistManager: PlaylistProtocol {
    var playlistLabel: String = String()
    var playlistURL: String = String()
}
