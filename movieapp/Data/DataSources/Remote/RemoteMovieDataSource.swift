//
//  RemoteMovieDataSource.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

actor RemoteMovieDataSource: MovieDataSourceProtocol {
    private let networkClient: NetworkClientProtocol
    private let apiKey: String
    private let baseURL: URL
    
    init(
        networkClient: NetworkClientProtocol,
        apiKey: String,
        baseURL: URL = URL(string: "https://api.themoviedb.org/3")!
    ) {
        self.networkClient = networkClient
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
    
    func getPopularMovies(page: Int) async throws -> [MovieDTO] {
        guard let url = URL(string: "/movie/popular", relativeTo: baseURL)?
            .appending(queryItems: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: String(page))
            ])
        else {
            throw NetworkError.invalidURL
        }
        
        let response: MovieResponseDTO = try await networkClient.request(
            url: url,
            method: .get,
            headers: nil,
            body: nil
        )
        
        return response.results
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDTO {
        guard let url = URL(string: "/movie/\(id)", relativeTo: baseURL)?
            .appending(queryItems: [
                URLQueryItem(name: "api_key", value: apiKey)
            ])
        else {
            throw NetworkError.invalidURL
        }
        
        return try await networkClient.request(
            url: url,
            method: .get,
            headers: nil,
            body: nil
        )
    }
    
    func searchMovies(query: String, page: Int) async throws -> [MovieDTO] {
        guard let url = URL(string: "/search/movie", relativeTo: baseURL)?
            .appending(queryItems: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page))
            ])
        else {
            throw NetworkError.invalidURL
        }
        
        let response: MovieResponseDTO = try await networkClient.request(
            url: url,
            method: .get,
            headers: nil,
            body: nil
        )
        
        return response.results
    }
}
