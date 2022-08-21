//
//  NowPlayingProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import UIKit
import MusicKit

public protocol NowPlayingProtocol: ObservableObject {
    var playButtonState: PlayButton { get set }
    var currentTrack: Track? { get set }
    var currentAudioFeatures: AudioFeatures? { get set }
}

class MockNowPlayingManager: NowPlayingProtocol {
    var playButtonState: PlayButton = .notPlaying
    var currentTrack: Track? = nil
    var currentAudioFeatures: AudioFeatures? = nil
}
