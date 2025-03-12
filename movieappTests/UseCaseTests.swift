//
//  UseCaseTests.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Testing
@testable import movieapp

@Suite("UseCaseTests")
struct UseCaseTests {
    
    @Test("GetPopularMoviesUseCase should return movies from repository")
    func testGetPopularMoviesUseCase() async throws {
        // Arrange
        let mockRepository = MockMovieRepository()
        let useCase = GetPopularMoviesUseCase(repository: mockRepository)
        
        // Act
        let movies = try await useCase.execute(page: 1)
        
        // Assert
        #expect(movies.count == 2)
        #expect(movies[0].title == "Movie 1")
        #expect(movies[1].title == "Movie 2")
    }
    
    @Test("GetMovieDetailsUseCase should return movie details")
    func testGetMovieDetailsUseCase() async throws {
        // Arrange
        let mockRepository = MockMovieRepository()
        let useCase = GetMovieDetailsUseCase(repository: mockRepository)
        
        // Act
        let movie = try await useCase.execute(id: 1)
        
        // Assert
        #expect(movie.id == 1)
        #expect(movie.title == "Movie Detail 1")
        #expect(movie.overview == "Detailed overview")
    }
    
    @Test("SearchMoviesUseCase should return search results")
    func testSearchMoviesUseCase() async throws {
        // Arrange
        let mockRepository = MockMovieRepository()
        let useCase = SearchMoviesUseCase(repository: mockRepository)
        
        // Act
        let movies = try await useCase.execute(query: "test", page: 1)
        
        // Assert
        #expect(movies.count == 1)
        #expect(movies[0].title == "Search Result")
    }

    @Test("GetPopularMoviesUseCase should handle repository errors")
    func testGetPopularMoviesUseCaseError() async {
        // Arrange
        let mockRepository = MockMovieRepository(shouldFail: true)
        let useCase = GetPopularMoviesUseCase(repository: mockRepository)
        
        // Act & Assert
        do {
            _ = try await useCase.execute(page: 1)
            #expect(Bool(false), "Expected error to be thrown")
        } catch let error as NetworkError {
            switch error {
            case .serverError(let statusCode):
                #expect(statusCode == 500)
            default:
                #expect(Bool(false), "Unexpected NetworkError case: \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
    
    @Test("GetMovieDetailsUseCase should handle repository errors")
    func testGetMovieDetailsUseCaseError() async {
        // Arrange
        let mockRepository = MockMovieRepository(shouldFail: true)
        let useCase = GetMovieDetailsUseCase(repository: mockRepository)
        
        // Act & Assert
        do {
            _ = try await useCase.execute(id: 1)
            #expect(Bool(false), "Expected error to be thrown")
        } catch let error as NetworkError {
            switch error {
            case .serverError(let statusCode):
                #expect(statusCode == 500)
            default:
                #expect(Bool(false), "Unexpected NetworkError case: \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
    
    @Test("SearchMoviesUseCase should handle repository errors")
    func testSearchMoviesUseCaseError() async {
        // Arrange
        let mockRepository = MockMovieRepository(shouldFail: true)
        let useCase = SearchMoviesUseCase(repository: mockRepository)
        
        // Act & Assert
        do {
            _ = try await useCase.execute(query: "test", page: 1)
            #expect(Bool(false), "Expected error to be thrown")
        } catch let error as NetworkError {
            switch error {
            case .serverError(let statusCode):
                #expect(statusCode == 500)
            default:
                #expect(Bool(false), "Unexpected NetworkError case: \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
}
