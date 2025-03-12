
//
//  MovieListViewModelTests.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Testing
@testable import movieapp

@MainActor
@Suite("MovieListViewModelTests")
struct MovieListViewModelTests {
    
    @Test("Loading movies should update state correctly")
    func testLoadMoviesSuccess() async throws {
        let mockUseCase = MockFetchMoviesUseCase()
        let viewModel = MovieListViewModel(
            getPopularMoviesUseCase: mockUseCase,
            searchMoviesUseCase: MockSearchMoviesUseCase()
        )
        
        await viewModel.loadMovies()
        
        if case .loaded(let movies) = viewModel.state {
            #expect(movies.count == 2)
            #expect(movies[0].title == "Test Movie 1")
            #expect(movies[1].title == "Test Movie 2")
        } else {
            #expect(Bool(false), "Expected loaded state with movies")
        }
    }
    
    @Test("Loading movies should handle errors")
    func testLoadMoviesFailure() async throws {
        let mockUseCase = MockFetchMoviesUseCase(shouldFail: true)
        let viewModel = MovieListViewModel(
            getPopularMoviesUseCase: mockUseCase,
            searchMoviesUseCase: MockSearchMoviesUseCase()
        )
        
        await viewModel.loadMovies()
        
        if case .error(let errorMessage) = viewModel.state {
            #expect(errorMessage == "Server error (500)")
        } else {
            #expect(Bool(false), "Expected error state")
        }
    }
    
    @Test("Searching movies should filter correctly")
    func testSearchMovies() async throws {
        let mockUseCase = MockSearchMoviesUseCase()
        let viewModel = MovieListViewModel(
            getPopularMoviesUseCase: MockFetchMoviesUseCase(),
            searchMoviesUseCase: mockUseCase
        )
        
        viewModel.searchQuery = "Marvel"
        await viewModel.searchMovies()
        
        if case .loaded(let movies) = viewModel.state {
            #expect(movies.count == 1)
            #expect(movies[0].title == "Marvel Movie")
        } else {
            #expect(Bool(false), "Expected loaded state with search results")
        }
    }
    
    @Test("Empty search results should show empty state")
    func testEmptySearchResults() async throws {
        let mockUseCase = MockSearchMoviesUseCase(returnEmpty: true)
        let viewModel = MovieListViewModel(
            getPopularMoviesUseCase: MockFetchMoviesUseCase(),
            searchMoviesUseCase: mockUseCase
        )
        
        viewModel.searchQuery = "NonexistentMovie"
        await viewModel.searchMovies()
        
        #expect(viewModel.state == .empty, "Expected empty state")
    }
    
    @Test("Clearing search should refresh movies")
    func testClearingSearch() async throws {
        let mockUseCase = MockFetchMoviesUseCase()
        let viewModel = MovieListViewModel(
            getPopularMoviesUseCase: mockUseCase,
            searchMoviesUseCase: MockSearchMoviesUseCase()
        )
        
        viewModel.searchQuery = "Marvel"
        await viewModel.searchMovies()
        
        viewModel.clearSearch()
        
        #expect(viewModel.searchQuery == "", "Search query should be cleared")
        
        await viewModel.loadMovies()
        
        if case .loaded(let movies) = viewModel.state {
            #expect(movies.count == 2, "Should load original movies")
        } else {
            #expect(Bool(false), "Expected loaded state with original movies")
        }
    }
    
    @Test("Loading next page should append movies")
    func testLoadNextPage() async throws {
        let mockUseCase = MockPaginatedMoviesUseCase()
        let viewModel = MovieListViewModel(
            getPopularMoviesUseCase: mockUseCase,
            searchMoviesUseCase: MockSearchMoviesUseCase()
        )
        
        // Load first page
        await viewModel.loadMovies()
        
        // Load second page
        await viewModel.loadNextPage()
        
        if case .loaded(let movies) = viewModel.state {
            #expect(movies.count == 4, "Should have 4 movies from 2 pages")
            #expect(movies[0].title == "Test Movie 1")
            #expect(movies[3].title == "Test Movie 4")
        } else {
            #expect(Bool(false), "Expected loaded state with paginated movies")
        }
    }
}

// Mock implementations for testing
struct MockFetchMoviesUseCase: GetPopularMoviesUseCaseProtocol {
    let shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func execute(page: Int) async throws -> [Movie] {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
        
        return [
            Movie(id: 1, title: "Test Movie 1", overview: "Overview 1", posterPath: nil, releaseDate: "2023-01-01", rating: 8.0),
            Movie(id: 2, title: "Test Movie 2", overview: "Overview 2", posterPath: nil, releaseDate: "2023-01-02", rating: 7.5)
        ]
    }
}

struct MockSearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    let returnEmpty: Bool
    
    init(returnEmpty: Bool = false) {
        self.returnEmpty = returnEmpty
    }
    
    func execute(query: String, page: Int) async throws -> [Movie] {
        if returnEmpty {
            return []
        }
        
        return [
            Movie(id: 3, title: "Marvel Movie", overview: "A superhero movie", posterPath: nil, releaseDate: "2023-03-01", rating: 8.5)
        ]
    }
}

struct MockPaginatedMoviesUseCase: GetPopularMoviesUseCaseProtocol {
    func execute(page: Int) async throws -> [Movie] {
        if page == 1 {
            return [
                Movie(id: 1, title: "Test Movie 1", overview: "Overview 1", posterPath: nil, releaseDate: "2023-01-01", rating: 8.0),
                Movie(id: 2, title: "Test Movie 2", overview: "Overview 2", posterPath: nil, releaseDate: "2023-01-02", rating: 7.5)
            ]
        } else {
            return [
                Movie(id: 3, title: "Test Movie 3", overview: "Overview 3", posterPath: nil, releaseDate: "2023-01-03", rating: 9.0),
                Movie(id: 4, title: "Test Movie 4", overview: "Overview 4", posterPath: nil, releaseDate: "2023-01-04", rating: 6.5)
            ]
        }
    }
}

