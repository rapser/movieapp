//
//  GetPopularMoviesUseCase.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

protocol GetPopularMoviesUseCaseProtocol {
    func execute(page: Int) async throws -> [Movie]
}

struct GetPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> [Movie] {
        return try await repository.getPopularMovies(page: page)
    }
}
