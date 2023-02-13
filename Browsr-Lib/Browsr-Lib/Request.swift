//
//  Request.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

public protocol Request {
    associatedtype E: Endpoint
    
    var endpoint: E { get }
    var headers: [String: String] { get }
}

public extension Request {
    var headers: [String: String] {
        ["Content-Type": "application/json", "Authorization": "Bearer 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"]
    }
}
