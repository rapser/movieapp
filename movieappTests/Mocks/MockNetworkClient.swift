//
//  MockNetworkClient.swift
//  movieapp
//
//  Created by miguel tomairo on 10/03/25.
//

import Foundation

struct MockNetworkClient: NetworkClientProtocol {
    let shouldFail: Bool
    let mockResponseFile: String?
    let customRequestHandler: ((URL, HTTPMethod, [String: String]?, Data?) async throws -> Any)?
    
    init(shouldFail: Bool = false, mockResponseFile: String? = nil) {
        self.shouldFail = shouldFail
        self.mockResponseFile = mockResponseFile
        self.customRequestHandler = nil
    }
    
    init(customRequestHandler: @escaping (URL, HTTPMethod, [String: String]?, Data?) async throws -> Any) {
        self.shouldFail = false
        self.mockResponseFile = nil
        self.customRequestHandler = customRequestHandler
    }
    
    func request<T: Decodable>(url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?) async throws -> T {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
        
        if let customRequestHandler = customRequestHandler {
            let result = try await customRequestHandler(url, method, headers, body)
            if let typedResult = result as? T {
                return typedResult
            } else {
                throw NetworkError.decodingFailed(NSError(domain: "test", code: 1, userInfo: nil))
            }
        }
        
        if let mockResponseFile = mockResponseFile, let path = Bundle.main.path(forResource: mockResponseFile, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(T.self, from: data)
        }
        
        // Default mock response for MovieResponseDTO
        if T.self == MovieResponseDTO.self {
            let response = MovieResponseDTO(
                page: 1,
                results: [
                    MovieDTO(id: 1, title: "The Movie Title", overview: "Overview", posterPath: "/poster.jpg", releaseDate: "2023-01-01", voteAverage: 8.0),
                    MovieDTO(id: 2, title: "Another Movie", overview: "Overview 2", posterPath: "/poster2.jpg", releaseDate: "2023-01-02", voteAverage: 7.5)
                ],
                totalPages: 10,
                totalResults: 100
            )
            return response as! T
        }
        
        // Default mock response for MovieDTO
        if T.self == MovieDTO.self {
            let movie = MovieDTO(id: 1, title: "The Movie Title", overview: "Overview", posterPath: "/poster.jpg", releaseDate: "2023-01-01", voteAverage: 8.0)
            return movie as! T
        }
        
        throw NetworkError.dataNotFound
    }
}
