//
//  AMArtworkGateway.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/08/2022.
//

import Foundation
import SwiftyJSON

public class ArtworkGateway {
    var userToken: String
    var storefrontID: String
    
    public init(token: String, storeFront: String) {
        userToken = token
        storefrontID = storeFront
    }
    
    func getArtworkURL(id: String, completionHandler: @escaping (String) -> Void) {
        if let musicURL = URL(string: "\(K.MusicStore.url)catalog/\(storefrontID)/songs/\(id)") {
            var musicRequest = URLRequest(url: musicURL)
            musicRequest.httpMethod = "GET"
            musicRequest.addValue(K.MusicStore.bearerToken, forHTTPHeaderField: K.MusicStore.authorisation)

            URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                guard error == nil else { return }
                if let d = data {
                    if let artworkString = self.parseTrackForArtwork(data: d) {
                        completionHandler(artworkString)
                    }
                }
            }.resume()
        }
    }
    
    func parseTrackForArtwork(data: Data) -> String? {
        if let jsonData = try? JSON(data: data) {
            if let tracks = jsonData["data"].array {
                for track in tracks {
                    if let artworkURL = track["attributes"]["artwork"]["url"].string {
                        return artworkURL
                    }
                }
            }
        }
        return nil
    }
}
