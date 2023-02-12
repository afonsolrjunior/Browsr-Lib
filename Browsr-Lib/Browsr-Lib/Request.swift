//
//  Request.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

protocol Request {
    associatedtype E: Endpoint
    
    var endpoint: E { get }
    var headers: [String: String] { get }
}

extension Request {
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}
