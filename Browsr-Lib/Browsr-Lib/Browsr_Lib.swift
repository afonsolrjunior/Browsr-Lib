//
//  Browsr_Lib.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine

public enum BrowsrLibError: Error {
    case generic
    case organizationNotFound
    case invalidUrl
    case decodingError
    case invalidStatusCode
    case custom(error: Error)
}

public protocol OrganizationsService {
    func getOrganizations(request: OrganizationsRequest) -> AnyPublisher<OrganizationsPagedResponse, Error>
    func getOrganization(name: String) -> AnyPublisher<Organization, Error>
}

public protocol ImageDataService {
    func getImageData(for urlString: String) -> AnyPublisher<Data, Error>
}

final public class Browsr_Lib: OrganizationsService & ImageDataService {

    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func getOrganizations(request: OrganizationsRequest) -> AnyPublisher<OrganizationsPagedResponse, Error> {
        guard let url = request.endpoint.components.url else {
            return Fail(outputType: OrganizationsPagedResponse.self,
                        failure: BrowsrLibError.invalidUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.endpoint.method.rawValue
        
        var nextPageUrl = ""
        
        return self.urlSession.dataTaskPublisher(for: urlRequest).tryMap { element in
            guard let httpResponse = element.response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw BrowsrLibError.invalidStatusCode
            }
            
            if let headers = httpResponse.allHeaderFields as? [String: String] {
                nextPageUrl = headers["Link"] ?? ""
            }
            
            return element.data
        }.decode(type: [Organization].self, decoder: self.decoder).map { organizations in
            return OrganizationsPagedResponse(results: organizations, nextPageUrl: nextPageUrl)
        }.eraseToAnyPublisher()
    }
    
    public func getOrganization(name: String) -> AnyPublisher<Organization, Error> {
        let request = OrganizationsRequest(endpoint: .search(name: name))
        
        guard let url = request.endpoint.components.url else {
            return Fail(outputType: Organization.self,
                        failure: BrowsrLibError.invalidUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.endpoint.method.rawValue
        
        return self.urlSession.dataTaskPublisher(for: urlRequest).tryMap { element in
            guard let httpResponse = element.response as? HTTPURLResponse,
                   httpResponse.statusCode != 404 else {
                throw BrowsrLibError.organizationNotFound
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw BrowsrLibError.invalidStatusCode
            }
            
            return element.data
        }.decode(type: Organization.self, decoder: self.decoder)
            .eraseToAnyPublisher()

    }
    
    public func getImageData(for urlString: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(outputType: Data.self,
                        failure: BrowsrLibError.invalidUrl).eraseToAnyPublisher()
        }
        
        let urlRequest = URLRequest(url: url)
        
        return self.urlSession.dataTaskPublisher(for: urlRequest).tryMap { element in
            guard let httpResponse = element.response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw BrowsrLibError.invalidStatusCode
            }
            return element.data
        }.eraseToAnyPublisher()

    }
    
}
