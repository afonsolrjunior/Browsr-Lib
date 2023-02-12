//
//  Organization.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

public struct OrganizationsPagedResponse {
    let results: [Organization]
    let nextPageUrl: String
}

public struct Organization: Decodable {
    let name: String
    let avatarUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarUrlString = "avatar_url"
    }
}
