//
//  OrganizationsRequest.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

public struct OrganizationsRequest: Request {
    public let endpoint: OrganizationsEndpoint
    
    public init(endpoint: OrganizationsEndpoint) {
        self.endpoint = endpoint
    }
    
}
