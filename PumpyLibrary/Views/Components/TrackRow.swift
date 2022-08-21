//
//  TrackRow.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 02/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import MediaPlayer

public struct TrackRow<T: TokenProtocol, N:NowPlayingProtocol, B:BlockedTracksProtocol>: View {
    
    var track: Track
    @State private var image: UIImage = UIImage(imageLiteralResourceName: K.defaultArtwork)
    @EnvironmentObject var tokenManager: T

    public init(track: Track) {
        self.track = track
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 5.0) {
                HStack(alignment: .center, spacing: 10.0) {
                    Text(track.name ?? "N/A")
                        .font(.headline)
                        .lineLimit(1)
                    if track.isExplicitItem {
                        Image(systemName: "e.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12, alignment: .center)
                    }
                }
                Text(track.artist ?? "N/A")
                    .font(.subheadline)
                    .lineLimit(1)
            }
            Spacer()
            DislikeButton<N,B>(track: track, size: 20).padding(.horizontal)
        }
        .padding(.all, 5.0)
        .onAppear() {
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .clear
            Artwork(token: tokenManager.appleMusicToken, store: tokenManager.appleMusicStoreFront)
                .getArtwork(from: track, size: 50) { (artwork) in
                if let a = artwork {
                    image = a
                }
            }
        }
    }
}

#if DEBUG
struct TrackRow_Previews: PreviewProvider {
    
    static let track = PreviewTrack(name: "Song name", artist: "Artist name", playbackStoreID: "", isExplicitItem: true)
    
    static var previews: some View {
        TrackRow<MockTokenManager, MockNowPlayingManager, MockBlockedTracks>(track: track)
    }
}
#endif
