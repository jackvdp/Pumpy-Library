//
//  UpNextView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import MediaPlayer
import Introspect

public struct UpNextView<Q: QueueProtocol, N:NowPlayingProtocol, B:BlockedTracksProtocol, T: TokenProtocol>: View {
    
    @EnvironmentObject var queueManager: Q
    var fontStyle: Font
    var subFontOpacity: Double
    var showButton: Bool
    
    public init(fontStyle: Font = .subheadline, opacity: Double = 1.0, showButton: Bool = true) {
        self.fontStyle = fontStyle
        self.subFontOpacity = opacity
        self.showButton = showButton
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            List {
                if queueManager.queueTracks.isNotEmpty && queueManager.queueIndex > 0 {
                    Section(header: Text("History")) {
                        ForEach(0..<queueManager.queueIndex, id: \.self) { i in
                            TrackRow<T,N,B>(track: queueManager.queueTracks[i])
                                .deleteDisabled(true)
                                .foregroundColor(.white)
                                .id(queueManager.queueTracks[i].playbackStoreID)
                        }
                        .listRowBackground(Color.clear)
                        .animation(.easeIn(duration: 0.5))
                    }
                }
                if queueManager.queueIndex < queueManager.queueTracks.count {
                    Section(header: Text("Now Playing")) {
                        TrackRow<T,N,B>(track: queueManager.queueTracks[queueManager.queueIndex])
                            .deleteDisabled(true)
                            .foregroundColor(.white)
                            .id(queueManager.queueTracks[queueManager.queueIndex].playbackStoreID)
                    }
                    .listRowBackground(Color.clear)
                }
                if queueManager.queueIndex + 1 < queueManager.queueTracks.count {
                     Section(header: Text("Playing Next")) {
                        ForEach(queueManager.queueIndex + 1..<queueManager.queueTracks.count, id: \.self) { i in
                            TrackRow<T,N,B>(track: queueManager.queueTracks[i])
                                .foregroundColor(.white)
                                .id(queueManager.queueTracks[i].playbackStoreID)
                        }
                        .onDelete { indexSet in
                            removeRowsFromUpNext(at: indexSet)
                        }
                        .listRowBackground(Color.clear)
                        .animation(.easeIn(duration: 0.5))
                    }
                }
            }
            .listStyle(.plain)
            .onChange(of: queueManager.queueIndex) { tracks in
                scroll(proxy)
            }
            .onAppear() {
                scroll(proxy)
            }
            .mask(UpNextMask())
        }
    }
  
    func scroll(_ proxy: ScrollViewProxy) {
        if let track = queueManager.queueTracks[safe: queueManager.queueIndex + 1] {
            withAnimation {
                proxy.scrollTo(track.playbackStoreID, anchor: .top)
            }
        }
    }
    
    func removeRowsFromUpNext(at offsets: IndexSet) {
        for i in offsets {
            if queueManager.queueTracks.indices.contains(i) {
                let track = queueManager.queueTracks[i]
                queueManager.queueTracks.remove(at: i)
                queueManager.removeFromQueue(id: track.playbackStoreID)
            }
        }
    }
}





#if DEBUG
struct UpNextView_Previews: PreviewProvider {
    
    static let queueManager = MockQueueManager()
    
    static var previews: some View {
        
        queueManager.queueTracks = [
            MockData.track,
            MockData.track,
            MockData.track,
            MockData.track
        ]
        
        return UpNextView<
            MockQueueManager,
            MockNowPlayingManager,
            MockBlockedTracks,
            MockTokenManager
        >()
            .environmentObject(queueManager)
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockTokenManager())
    }
}
#endif

struct UpNextMask: View {
    var body: some View {
        LinearGradient(
            gradient:
                Gradient(colors:
                            Array<Color>(repeating: .white, count: 12) + Array<Color>(repeating: .white.opacity(0), count: 1)),
            startPoint: .top,
            endPoint: .bottom)
    }
}
