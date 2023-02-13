//
//  OrganizationsEndpoint.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

public enum OrganizationsEndpoint: Endpoint {
    case organizations(nextPagePath: String? = nil)
    case search(name: String)
    
    public var baseURL: String {
        switch self {
            default:
                return "api.github.com"
        }
    }
    
    public var path: String {
        switch self {
            case .organizations:
                return "/organizations"
            case .search(let name):
                return "/orgs/\(name)"
        }
    }
    
    public var queryString: String? {
        switch self {
            case .organizations(let nextPagePath):
                if let nextPagePath {
                    return nextPagePath
                }
                return nil
            case .search:
                return nil
        }
    }
    
    
}
