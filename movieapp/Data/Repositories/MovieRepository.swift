//
//  MovieRepository.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

protocol MovieRepositoryProtocol {
    func getPopularMovies(page: Int) async throws -> [Movie]
    func getMovieDetails(id: Int) async throws -> Movie
    func searchMovies(query: String, page: Int) async throws -> [Movie]
}

final class MovieRepository: MovieRepositoryProtocol {
    private let remoteDataSource: MovieDataSourceProtocol
    private let localDataSource: MovieDataSourceProtocol
    private let offlineFirst: Bool
    
    init(
        remoteDataSource: MovieDataSourceProtocol,
        localDataSource: MovieDataSourceProtocol,
        offlineFirst: Bool = false
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.offlineFirst = offlineFirst
    }
    
    func getPopularMovies(page: Int) async throws -> [Movie] {
        return try await fetchMovies(
            fromLocal: { try await localDataSource.getPopularMovies(page: page) },
            fromRemote: { try await remoteDataSource.getPopularMovies(page: page) }
        )
    }
    
    func getMovieDetails(id: Int) async throws -> Movie {
        return try await fetchMovie(
            fromLocal: { try await localDataSource.getMovieDetails(id: id) },
            fromRemote: { try await remoteDataSource.getMovieDetails(id: id) }
        )
    }
    
    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        return try await fetchMovies(
            fromLocal: { try await localDataSource.searchMovies(query: query, page: page) },
            fromRemote: { try await remoteDataSource.searchMovies(query: query, page: page) }
        )
    }
    
    // MARK: - Private Helpers
    
    private func fetchMovies(
        fromLocal: () async throws -> [MovieDTO],
        fromRemote: () async throws -> [MovieDTO]
    ) async throws -> [Movie] {
        if offlineFirst {
            do {
                let localMovies = try await fromLocal()
                if !localMovies.isEmpty { return localMovies.map { $0.toDomain() } }
            } catch {
                print("⚠️ Local data fetch failed: \(error.localizedDescription)")
            }
        }
        let remoteMovies = try await fromRemote()
        return remoteMovies.map { $0.toDomain() }
    }
    
    private func fetchMovie(
        fromLocal: () async throws -> MovieDTO,
        fromRemote: () async throws -> MovieDTO
    ) async throws -> Movie {
        if offlineFirst {
            do {
                return try await fromLocal().toDomain()
            } catch {
                print("⚠️ Local data fetch failed: \(error.localizedDescription)")
            }
        }
        return try await fromRemote().toDomain()
    }
}


