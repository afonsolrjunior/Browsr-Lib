//
//  OrganizationsEndpoint.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

enum OrganizationsEndpoint: Endpoint {
    case organizations
    case search(name: String)
    
    var baseURL: String {
        switch self {
            default:
                return "api.github.com"
        }
    }
    
    var path: String {
        switch self {
            case .organizations:
                return "/organizations"
            case .search(let name):
                return "/orgs/\(name)"
        }
    }
    
    
}
