//
//  MockMovieDataSource.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

class MockMovieDataSource: MovieDataSourceProtocol {
    func getPopularMovies(page: Int) async throws -> [MovieDTO] {
        // Simular delay de red
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return [
            MovieDTO(
                id: 1,
                title: "Película de prueba 1",
                overview: "Esta es una película de prueba",
                posterPath: "/path/to/poster1.jpg",
                releaseDate: "2023-01-01",
                voteAverage: 8.5
            ),
            MovieDTO(
                id: 2,
                title: "Película de prueba 2",
                overview: "Esta es otra película de prueba",
                posterPath: "/path/to/poster2.jpg",
                releaseDate: "2023-02-15",
                voteAverage: 7.8
            )
        ]
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDTO {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return MovieDTO(
            id: id,
            title: "Detalles de película \(id)",
            overview: "Esta es una descripción detallada de la película \(id)",
            posterPath: "/path/to/poster\(id).jpg",
            releaseDate: "2023-03-01",
            voteAverage: 8.0
        )
    }
    
    func searchMovies(query: String, page: Int) async throws -> [MovieDTO] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return [
            MovieDTO(
                id: 3,
                title: "Resultado de búsqueda para \(query)",
                overview: "Esta película coincide con tu búsqueda",
                posterPath: "/path/to/poster3.jpg",
                releaseDate: "2023-04-20",
                voteAverage: 6.9
            )
        ]
    }
}
