//
//  Endpoint.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

internal enum EndpointScheme: String {
    case http
    case https
}

internal enum RESTMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

internal protocol Endpoint {
    var scheme: EndpointScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var method: RESTMethod { get }
    var components: URLComponents { get }
}

internal extension Endpoint {
    var components: URLComponents {
        var components = URLComponents()
        
        components.scheme = self.scheme.rawValue
        components.host = self.baseURL
        components.path = self.path
        
        return components
    }
    
    var method: RESTMethod {
        .get
    }
    
    var scheme: EndpointScheme {
        .https
    }
    
}

