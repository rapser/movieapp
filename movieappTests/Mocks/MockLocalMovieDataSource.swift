//
//  MockLocalMovieDataSource.swift
//  movieapp
//
//  Created by miguel tomairo on 10/03/25.
//

import Foundation

struct MockLocalMovieDataSource: MovieDataSourceProtocol {
    let shouldFail: Bool
    private(set) var savedMoviesCount = 0
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    mutating func saveMovies(_ movies: [MovieDTO]) {
        savedMoviesCount += movies.count
    }
    
    func getPopularMovies(page: Int) async throws -> [MovieDTO] {
        if shouldFail {
            throw NetworkError.dataNotFound
        }
        
        return [
            MovieDTO(id: 1, title: "Local Movie 1", overview: "Cached Overview", posterPath: nil, releaseDate: "2023-01-01", voteAverage: 8.0)
        ]
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDTO {
        if shouldFail {
            throw NetworkError.dataNotFound
        }
        
        return MovieDTO(id: id, title: "Local Movie \(id)", overview: "Cached Overview", posterPath: nil, releaseDate: "2023-01-01", voteAverage: 8.0)
    }
    
    func searchMovies(query: String, page: Int) async throws -> [MovieDTO] {
        if shouldFail {
            throw NetworkError.dataNotFound
        }
        
        return [
            MovieDTO(id: 3, title: "Local Search Result", overview: "Cached Overview", posterPath: nil, releaseDate: "2023-01-03", voteAverage: 8.5)
        ]
    }
}
