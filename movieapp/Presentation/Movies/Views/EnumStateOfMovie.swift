//
//  EnumStateOfMovie.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

enum MovieListState: Equatable {
    case idle
    case loading
    case loaded([Movie])
    case error(String)
    case empty
    
    static func == (lhs: MovieListState, rhs: MovieListState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsMovies), .loaded(let rhsMovies)):
            return lhsMovies == rhsMovies
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        case (.empty, .empty):
            return true
        default:
            return false
        }
    }
}
