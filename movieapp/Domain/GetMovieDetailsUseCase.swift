//
//  GetMovieDetailsUseCase.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

protocol GetMovieDetailsUseCaseProtocol {
    func execute(id: Int) async throws -> Movie
}

struct GetMovieDetailsUseCase: GetMovieDetailsUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> Movie {
        return try await repository.getMovieDetails(id: id)
    }
}
