//
//  Extensions.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 21/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import SwiftUI

extension MPVolumeView {
    public static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
    
    public static func getVolume() -> Float {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        print(slider?.value ?? 1)
        
        return slider?.value ?? 1
    }
}

extension View {
    public func isHidden(_ bool: Bool) -> some View {
        modifier(HiddenModifier(isHidden: bool))
    }
}

private struct HiddenModifier: ViewModifier {
    
    fileprivate let isHidden: Bool
    
    fileprivate func body(content: Content) -> some View {
        Group {
            if isHidden {
                content.hidden()
            } else {
                content
            }
        }
    }
}

extension Color {
    public static let greyBGColour = Color("lightGrey")
    public static let pumpyPink = Color(K.pumpyPink)
}

extension UIImageView {
    public func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension MPMediaItem {
    public var imageURL: String? {
        if let artworkCatalog = self.value(forKey: "artworkCatalog") as? NSObject,
           let token = artworkCatalog.value(forKey: "token") as? NSObject {
            return token.value(forKey: "fetchableArtworkToken") as? String
        }
        return nil
    }
}


public enum StandardError: Error {
    case error
}

public enum HTTPError: LocalizedError {
    case statusCode
}

extension StandardError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error:
            return NSLocalizedString("Error", comment: "Error")
        }
    }
}

public protocol PropertyLoopable {
    func allProperties() throws -> [String: Any]
}

extension String {
    public var safeCharacters: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return self.filter {okayChars.contains($0) }
    }
}

extension Date {
    public static func getCurrentTime() -> String {
        return Date().description(with: .current)
    }
}

extension DispatchSemaphore {
    
    @discardableResult
    public func with<T>(_ block: () throws -> T) rethrows -> T {
        wait()
        defer { signal() }
        return try block()
    }
}


extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Hashable {
    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating public func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension String {

    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}

extension Notification.Name {
    
    public static let SettingsUpdate = Notification.Name("SettingsUpdate")
    public static let AlarmTriggered = Notification.Name("AlarmTriggered")
    
}

extension Array {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

@propertyWrapper
public struct CodableIgnored<T>: Codable {
    public var wrappedValue: T?
        
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        self.wrappedValue = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        // Do nothing
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: CodableIgnored<T>.Type,
        forKey key: Self.Key) throws -> CodableIgnored<T>
    {
        return CodableIgnored(wrappedValue: nil)
    }
}

extension KeyedEncodingContainer {
    public mutating func encode<T>(
        _ value: CodableIgnored<T>,
        forKey key: KeyedEncodingContainer<K>.Key) throws
    {
        // Do nothing
    }
}
