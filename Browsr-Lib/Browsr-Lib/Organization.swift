//
//  Organization.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

public struct OrganizationsPagedResponse {
    public let results: [Organization]
    public let nextPageUrl: String
}

public struct Organization: Decodable {
    public let name: String
    public let avatarUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarUrlString = "avatar_url"
    }
}
