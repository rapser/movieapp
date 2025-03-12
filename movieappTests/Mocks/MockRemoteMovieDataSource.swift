//
//  MockRemoteMovieDataSource.swift
//  movieapp
//
//  Created by miguel tomairo on 10/03/25.
//

import Foundation

struct MockRemoteMovieDataSource: MovieDataSourceProtocol {
    let shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func getPopularMovies(page: Int) async throws -> [MovieDTO] {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
        
        return [
            MovieDTO(id: 1, title: "Remote Movie 1", overview: "Overview", posterPath: nil, releaseDate: "2023-01-01", voteAverage: 8.0),
            MovieDTO(id: 2, title: "Remote Movie 2", overview: "Overview", posterPath: nil, releaseDate: "2023-01-02", voteAverage: 7.5)
        ]
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDTO {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
        
        return MovieDTO(id: id, title: "Remote Movie \(id)", overview: "Overview", posterPath: nil, releaseDate: "2023-01-01", voteAverage: 8.0)
    }
    
    func searchMovies(query: String, page: Int) async throws -> [MovieDTO] {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
        
        return [
            MovieDTO(id: 3, title: "Remote Search Result", overview: "Overview", posterPath: nil, releaseDate: "2023-01-03", voteAverage: 8.5)
        ]
    }
}
