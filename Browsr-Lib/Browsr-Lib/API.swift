//
//  API.swift
//  Browsr-Lib
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine

internal enum APIError: Error {
    case invalidUrl
    case decoding(error: Error)
    case invalidStatusCode
    case custom(errorMessage: String)
    case generic
}

final internal class API {
    
    private let urlSession: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func execute<T: Decodable>(request: any Request, returningType: T.Type) -> AnyPublisher<T, Error> {
        
        return Future {[weak self] promise in
            guard let self else {
                promise(Result.failure(APIError.generic))
                return
            }
            
            guard let url = request.endpoint.components.url else {
                promise(Result.failure(APIError.invalidUrl))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpMethod = request.endpoint.method.rawValue
            
            let dataTaskPublisher = self.urlSession.dataTaskPublisher(for: urlRequest).tryMap { element in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    throw APIError.invalidStatusCode
                }
                return element.data
            }.decode(type: T.self, decoder: self.decoder)
            
        }.eraseToAnyPublisher()
        
    }
    
}
