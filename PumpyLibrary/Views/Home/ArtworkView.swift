//
//  BackgroundView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import MusicKit

public struct ArtworkView<N:NowPlayingProtocol>: View {
    
    public init(contentType: ArtworkView<N>.Content, blur: Int = 100) {
        self.contentType = contentType
        self.blur = blur
    }
    
    let contentType: Content
    var blur = 100
    let defaultArtwork = UIImage(imageLiteralResourceName: K.defaultArtwork)
    
    @EnvironmentObject var nowPlayingManager: N
    
    public var body: some View {
        ZStack {
            switch contentType {
            case .artwork:
                if let artwork = nowPlayingManager.currentTrack?.musicKitArtwork {
                    ArtworkImage(artwork, width: 500)
                        .cornerRadius(10)
                } else {
                    Image(uiImage: defaultArtwork)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(10)
                }
            case .background:
                BackgroundImage(track: nowPlayingManager.currentTrack, blur: blur)
            }
        }
    }
    
    
}

#if DEBUG
struct ArtworkView_Previews: PreviewProvider {

    static var previews: some View {
        ArtworkView<MockNowPlayingManager>(contentType: .artwork)
    }
}
#endif


extension ArtworkView {
    
    struct BackgroundImage: View {
        
        var track: Track?
        let blur: Int
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    if let artwork = track?.musicKitArtwork {
                        ArtworkImage(artwork, width: 500)
                            .blur(radius: geometry.size.height / 17, opaque: true)
                    } else {
                        BackgroundView()
                    }
                    Rectangle().fill(
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.1), Color.black.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                    ).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
            }

        }
    }

    enum ImageChoice {
        case imageA
        case imageB
    }
    
    public enum Content {
        case artwork
        case background
    }
}

