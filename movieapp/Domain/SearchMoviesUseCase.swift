//
//  SearchMoviesUseCase.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

protocol SearchMoviesUseCaseProtocol {
    func execute(query: String, page: Int) async throws -> [Movie]
}

struct SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) async throws -> [Movie] {
        return try await repository.searchMovies(query: query, page: page)
    }
}
