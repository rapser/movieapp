//
//  MockMovieRepository.swift
//  movieapp
//
//  Created by miguel tomairo on 10/03/25.
//

struct MockMovieRepository: MovieRepositoryProtocol {
    let shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    private func throwIfNeeded() throws {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
    }

    func getPopularMovies(page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        
        return [
            Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: nil, releaseDate: "2023-01-01", rating: 8.0),
            Movie(id: 2, title: "Movie 2", overview: "Overview 2", posterPath: nil, releaseDate: "2023-01-02", rating: 7.5)
        ]
    }

    func getMovieDetails(id: Int) async throws -> Movie {
        try throwIfNeeded()
        
        return Movie(id: id, title: "Movie Detail \(id)", overview: "Detailed overview", posterPath: nil, releaseDate: "2023-01-01", rating: 8.0)
    }

    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        
        return [
            Movie(id: 3, title: "Search Result", overview: "Search overview", posterPath: nil, releaseDate: "2023-01-03", rating: 8.5)
        ]
    }
}

