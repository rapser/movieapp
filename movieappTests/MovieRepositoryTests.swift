//
//  MovieRepositoryTests.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Testing
@testable import movieapp

@Suite("MovieRepositoryTests")
struct MovieRepositoryTests {
    
    @Test("Repository should fetch movies from remote data source")
    func testRepositoryFetchMovies() async throws {
        // Arrange
        let mockRemoteDataSource = MockRemoteMovieDataSource()
        let mockLocalDataSource = MockLocalMovieDataSource()
        let repository = MovieRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
        
        // Act
        let movies = try await repository.getPopularMovies(page: 1)
        
        // Assert
        #expect(movies.count == 2)
        #expect(movies[0].id == 1)
        #expect(movies[1].id == 2)
        #expect(movies[0].title == "Remote Movie 1")
    }
    
    @Test("Repository should save fetched movies to local data source")
    func testRepositorySavesToLocalDataSource() async throws {
        // Arrange
        let mockRemoteDataSource = MockRemoteMovieDataSource()
        let mockLocalDataSource = MockLocalMovieDataSource()
        let repository = MovieRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
        
        // Act
        _ = try await repository.getPopularMovies(page: 1)
        
        // Assert
        #expect(mockLocalDataSource.savedMoviesCount == 2, "Should have saved 2 movies locally")
    }
    
    @Test("Repository should fetch from local when offline")
    func testRepositoryFetchesFromLocalWhenOffline() async throws {
        // Arrange
        let mockRemoteDataSource = MockRemoteMovieDataSource(shouldFail: true)
        let mockLocalDataSource = MockLocalMovieDataSource()
        let repository = MovieRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource,
            offlineFirst: true
        )
        
        // Act
        let movies = try await repository.getPopularMovies(page: 1)
        
        // Assert
        #expect(movies.count == 1)
        #expect(movies[0].title == "Local Movie 1")
    }
    
    @Test("Repository should handle both sources failing")
    func testRepositoryHandlesBothSourcesFailing() async {
        // Arrange
        let mockRemoteDataSource = MockRemoteMovieDataSource(shouldFail: true)
        let mockLocalDataSource = MockLocalMovieDataSource(shouldFail: true)
        let repository = MovieRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        // Act & Assert
        do {
            _ = try await repository.getPopularMovies(page: 1)
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            if let networkError = error as? NetworkError {
                switch networkError {
                case .serverError(let statusCode):
                    #expect(statusCode == 500, "Expected status code 500, but got \(statusCode)")
                default:
                    #expect(Bool(false), "Expected .serverError, but got \(networkError)")
                }
            } else {
                #expect(Bool(false), "Expected NetworkError, but got \(error)")
            }
        }
    }
}
