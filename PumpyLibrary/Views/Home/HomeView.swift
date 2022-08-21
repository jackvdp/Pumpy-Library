//
//  HomeView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct HomeView<P: PlaylistProtocol,
                       Q:QueueProtocol,
                       N:NowPlayingProtocol,
                       B: BlockedTracksProtocol,
                       H:HomeProtocol,
                       T:TokenProtocol,
                       V: View>: View {
    
    public init(homeVM: H, menuView: V) {
        self._homeVM = StateObject(wrappedValue: homeVM)
        self.menuView = menuView
    }
    
    @StateObject var homeVM: H
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Namespace var controls
    @Namespace var labels
    @Namespace var background
    var menuView: V
    
    public var body: some View {
        NavigationView {
            playerView
                .navigationBarHidden(true)
                .navigationBarTitle("Player")
        }
        .accentColor(.pumpyPink)
        .environmentObject(homeVM)
        .navigationViewStyle(.stack)
    }
    
    var playerView: some View {
        VStack {
            NavigationBar<B, N, H, V>(destinationView: menuView)
            if isPortrait() {
                portraitView
            } else  {
                landscapeView
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            ArtworkView<N>(contentType: .background)
                .transaction { t in
                    t.animation = .none
                }
        )
    }
    
    var portraitView: some View {
        VStack {
            Spacer()
            switch homeVM.pageType {
            case .artwork:
                ArtworkView<N>(contentType: .artwork)
            case .upNext:
                UpNextView<Q,N,B,T>()
                    .padding(.horizontal, -20)
            }
            Spacer(minLength: 20)
            SongLabels<N,P>().id(labels)
            Spacer(minLength: 20)
            PlayerControls<P,N,H,Q>(isPortrait: isPortrait())
                .id(controls)
            Spacer(minLength: 20)
            VolumeControl()
        }
    }
    
    var landscapeView: some View {
        HStack(spacing: 5) {
            VStack {
                Spacer()
                ArtworkView<N>(contentType: .artwork)
                Spacer(minLength: 20)
                SongLabels<N,P>().id(labels)
                Spacer(minLength: 20)
                PlayerControls<P,N,H,Q>(isPortrait: isPortrait())
                    .id(controls)
                Spacer(minLength: 20)
                VolumeControl()
            }
            VStack {
                UpNextView<Q,N,B,T>()
            }
        }
    }
    
    func isPortrait() -> Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
    
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {

    static let homeVM = MockHomeVM()
    
    static var previews: some View {
        HomeView<MockPlaylistManager,
                 MockQueueManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockHomeVM,
                 MockTokenManager,
                 EmptyView>(homeVM: homeVM, menuView: EmptyView())
    }
}
#endif
