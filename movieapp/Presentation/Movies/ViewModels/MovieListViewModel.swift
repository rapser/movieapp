//
//  MovieListViewModel.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation
import Combine

@Observable
class MovieListViewModel: MovieListViewModelProtocol {
    private let getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    
    private var currentPage = 1
    private var canLoadMorePages = true
    private var isLoadingPage = false
    private var movies: [Movie] = []
    
    // Propiedades públicas
    var state: MovieListState = .idle
    var searchQuery: String = ""
    var isSearchActive: Bool { !searchQuery.isEmpty }
    
    init(
        getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol,
        searchMoviesUseCase: SearchMoviesUseCaseProtocol
    ) {
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
    }
    
    @MainActor
    func loadMovies() async {
        if case .loading = state { return }
        
        if isSearchActive {
            await searchMovies()
            return
        }
        
        guard !isLoadingPage && canLoadMorePages else { return }
        
        isLoadingPage = true
        state = movies.isEmpty ? .loading : state
        
        do {
            let newMovies = try await getPopularMoviesUseCase.execute(page: currentPage)
            
            self.movies.append(contentsOf: newMovies)
            self.state = .loaded(self.movies)
            self.currentPage += 1
            self.canLoadMorePages = !newMovies.isEmpty
        } catch {
            if movies.isEmpty {
                state = .error(error.localizedDescription)
            }
        }
        
        isLoadingPage = false
    }
    
    @MainActor
    func loadNextPage() async {
        await loadMovies()
    }
    
    @MainActor
    func refreshMovies() async {
        currentPage = 1
        canLoadMorePages = true
        movies = []
        state = .loading
        
        await loadMovies()
    }
    
    @MainActor
    func searchMovies() async {
        guard !searchQuery.isEmpty else {
            await refreshMovies()
            return
        }
        
        state = .loading
        movies = []
        currentPage = 1
        
        do {
            let searchResults = try await searchMoviesUseCase.execute(query: searchQuery, page: currentPage)
            
            self.movies = searchResults
            self.state = searchResults.isEmpty ? .empty : .loaded(searchResults)
            self.currentPage += 1
            self.canLoadMorePages = !searchResults.isEmpty
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func clearSearch() {
        searchQuery = ""
        Task {
            await refreshMovies()
        }
    }
}
