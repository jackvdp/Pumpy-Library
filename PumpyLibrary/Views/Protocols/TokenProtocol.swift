//
//  TokenProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol TokenProtocol: ObservableObject {
    var appleMusicToken: String? { get set }
    var appleMusicStoreFront: String? { get set }
}

class MockTokenManager: TokenProtocol {
    var appleMusicToken: String?
    var appleMusicStoreFront: String?
}
