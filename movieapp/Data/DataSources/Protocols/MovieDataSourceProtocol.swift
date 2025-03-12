//
//  MovieDataSourceProtocol.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

protocol MovieDataSourceProtocol {
    func getPopularMovies(page: Int) async throws -> [MovieDTO]
    func getMovieDetails(id: Int) async throws -> MovieDTO
    func searchMovies(query: String, page: Int) async throws -> [MovieDTO]
}
