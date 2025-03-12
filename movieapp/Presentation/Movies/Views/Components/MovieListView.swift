//
//  MovieListView.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import SwiftUI

struct MovieListView<ViewModel: MovieListViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Películas")
                .searchable(text: $viewModel.searchQuery, prompt: "Buscar películas")
                .onSubmit(of: .search) {
                    Task {
                        await viewModel.searchMovies()
                    }
                }
                .onChange(of: viewModel.searchQuery) { oldValue, newValue in
                    if newValue.isEmpty && !oldValue.isEmpty {
                        viewModel.clearSearch()
                    }
                }
                .toolbar {
                    if viewModel.isSearchActive {
                        Button("Cancelar") {
                            viewModel.clearSearch()
                        }
                    }
                }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
            
        case .loading:
            ProgressView("Cargando películas...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let movies):
            moviesList(movies)
            
        case .error(let message):
            errorView(message)
            
        case .empty:
            VStack(spacing: 16) {
                Image(systemName: "film")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("No se encontraron películas")
                    .font(.headline)
                
                if viewModel.isSearchActive {
                    Text("Intenta con otra búsqueda")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func moviesList(_ movies: [Movie]) -> some View {
        List {
            ForEach(movies) { movie in
                NavigationLink(destination: Text("Detalles de \(movie.title)")) {
                    MainRowSubView(movie: movie)
                }
                .id(movie.id)
            }
            
            if !viewModel.isSearchActive {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshMovies()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Ha ocurrido un error")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Reintentar") {
                Task {
                    await viewModel.refreshMovies()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    final class PreviewMovieListViewModel: MovieListViewModelProtocol {
        var state: MovieListState = .loaded([
            Movie(
                id: 1,
                title: "Spider-Man: No Way Home",
                overview: "Peter Parker busca la ayuda del Doctor Strange para olvidar su identidad expuesta...",
                posterPath: nil,
                releaseDate: "2021-12-15",
                rating: 8.2
            ),
            Movie(
                id: 2,
                title: "Dune",
                overview: "Paul Atreides, un joven brillante con un destino más allá de su comprensión...",
                posterPath: nil,
                releaseDate: "2021-10-01",
                rating: 7.9
            )
        ])
        
        var searchQuery: String = ""
        var isSearchActive: Bool { !searchQuery.isEmpty }
        
        func loadMovies() async {}
        func loadNextPage() async {}
        func refreshMovies() async {}
        func searchMovies() async {}
        func clearSearch() {}
    }
    
    return MovieListView(viewModel: PreviewMovieListViewModel())
}
