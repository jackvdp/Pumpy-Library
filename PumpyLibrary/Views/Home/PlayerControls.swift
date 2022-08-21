//
//  PlayerControls.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import AVKit
import MediaPlayer
import Firebase

struct PlayerControls<P:PlaylistProtocol,
                      N:NowPlayingProtocol,
                      H:HomeProtocol,
                      Q:QueueProtocol>: View {
    
    @EnvironmentObject var homeVM: H
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var queueManager: Q
    @EnvironmentObject var alarmData: AlarmData
    var isPortrait: Bool
    @State private var showingOptions: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 40.0) {
            changeEnergyButton
            if isPortrait { upNextButton }
            playButton
            fastForwardButton
        }
    }
    
    var playButton: some View {
        Image(systemName: nowPlayingManager.playButtonState == .playing ? "pause.fill" : "play.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40, alignment: .center)
            .accentColor(.white)
            .onTapGesture {
                homeVM.playPause()
            }
            .onLongPressGesture(minimumDuration: 2) {
                homeVM.coldStart()
            }
        
    }

    var fastForwardButton: some View {
        Button(action: {
            homeVM.skipToNextItem()
        }) {
            Image(systemName: "forward.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
                .accentColor(.white)
        }
        
    }

    var upNextButton: some View {
        Button(action: {
            withAnimation {
                switch homeVM.pageType {
                case .artwork:
                    homeVM.pageType = .upNext
                case .upNext:
                    homeVM.pageType = .artwork
                }
            }
        }) {
            Image(systemName: "list.bullet")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(homeVM.pageType == .upNext ? .pumpyPink : .white)
                .font(.title.weight(.light))
        }
    }
    
    var changeEnergyButton: some View {
        Button(action: {
            showingOptions = true
        }) {
            Image(systemName: "bolt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(queueManager.analysingEnergy ? .pumpyPink : .white)
                .disabled(queueManager.analysingEnergy)
                .font(.title.weight(.light))
        }
        .confirmationDialog("Change energy of upcoming tracks", isPresented: $showingOptions, titleVisibility: .visible) {
            Button {
                queueManager.increaseEnergy()
            } label: {
                Text("Increase Energy")
            }
            Button {
                queueManager.decreaseEnergy()
            } label: {
                Text("Decrease Energy")
            }
        }
        .buttonStyle(.plain)
    }

}

#if DEBUG
struct PlayerControls_Previews: PreviewProvider {

    static var previews: some View {
        PlayerControls<MockPlaylistManager,
                       MockNowPlayingManager,
                       MockHomeVM,
                       MockQueueManager>(isPortrait: false)
            .environmentObject(MockHomeVM())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmData(username: "Text", preview: true))
            .preferredColorScheme(.dark)
        PlayerControls<MockPlaylistManager,
                       MockNowPlayingManager,
                       MockHomeVM,
                       MockQueueManager>(isPortrait: true)
            .environmentObject(MockHomeVM())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmData(username: "Text", preview: true))
            .preferredColorScheme(.dark)
    }
}
#endif


