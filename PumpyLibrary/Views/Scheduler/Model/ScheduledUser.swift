//
//  ScheduledUser.swift
//  Scheduler
//
//  Created by Jack Vanderpump on 24/07/2022.
//

import Foundation

public protocol ScheduledUser {
    var username: String { get }
    var alarmData: AlarmData { get }
}

class MockUser: UserProtocol {
    typealias M = MockMusicMananger

    var username: String = "Test"
    var alarmData: AlarmData = AlarmData(username: "Test")
    var settingsManager: SettingsManager = SettingsManager(username: "Test")
    var externalDisplayManager: ExternalDisplayManager<MockPlaylistManager> = ExternalDisplayManager(username: "Test", playlistManager: MockPlaylistManager())
    var musicManager: MockMusicMananger = MockMusicMananger()
}

public protocol ScheduledPlaylist {
    var name: String? { get }
    var cloudGlobalID: String? { get }
}
