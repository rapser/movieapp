//
//  RemoteMovieDataSourceTests.swift
//  movieapp
//
//  Created by miguel tomairo on 10/03/25.
//

import Testing
@testable import movieapp

@Suite("RemoteMovieDataSourceTests")
struct RemoteMovieDataSourceTests {
    
    @Test("Remote data source should parse API response correctly")
    func testRemoteDataSourceParsing() async throws {
        // Arrange
        let mockNetworkClient = MockNetworkClient(mockResponseFile: "popular_movies")
        let dataSource = RemoteMovieDataSource(networkClient: mockNetworkClient, apiKey: "test_key")
        
        // Act
        let movies = try await dataSource.getPopularMovies(page: 1)
        
        // Assert
        #expect(movies.count == 2)
        #expect(movies[0].title == "The Movie Title")
        #expect(movies[0].releaseDate == "2023-01-01")
    }
    
    @Test("Remote data source should handle network errors")
    func testRemoteDataSourceNetworkError() async {
        // Arrange
        let mockNetworkClient = MockNetworkClient(shouldFail: true)
        let dataSource = RemoteMovieDataSource(networkClient: mockNetworkClient, apiKey: "test_key")
        
        // Act & Assert
        do {
            _ = try await dataSource.getPopularMovies(page: 1)
            #expect(Bool(false),"Expected error to be thrown")
        } catch {
            if let networkError = error as? NetworkError {
                switch networkError {
                case .serverError(let statusCode):
                    #expect(statusCode == 500)
                default:
                    #expect(Bool(false),"Expected .serverError, but got \(networkError)")
                }
            } else {
                #expect(Bool(false),"Expected NetworkError, but got \(error)")
            }
        }
    }
    
    @Test("Remote data source should correctly format search URL")
    func testRemoteDataSourceSearchFormatting() async throws {
        // Arrange
        let mockNetworkClient = MockNetworkClient { url, method, headers, body in
            #expect(url.absoluteString.contains("query=test%20query"))
            #expect(url.absoluteString.contains("page=1"))
            #expect(method == .get)
            
            return MovieResponseDTO(
                page: 1,
                results: [
                    MovieDTO(id: 1, title: "Test Movie", overview: "Overview", posterPath: nil, releaseDate: "2023-01-01", voteAverage: 8.0)
                ],
                totalPages: 1,
                totalResults: 1
            )
        }
        
        let dataSource = RemoteMovieDataSource(networkClient: mockNetworkClient, apiKey: "test_key")
        
        // Act
        let movies = try await dataSource.searchMovies(query: "test query", page: 1)
        
        // Assert
        #expect(movies.count == 1)
        #expect(movies[0].title == "Test Movie")
    }
}
