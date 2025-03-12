//
//  MovieListViewModelProtocol.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation
import Combine

protocol MovieListViewModelProtocol: ObservableObject {
    var state: MovieListState { get }
    var searchQuery: String { get set }
    var isSearchActive: Bool { get }
    
    func loadMovies() async
    func loadNextPage() async
    func refreshMovies() async
    func searchMovies() async
    func clearSearch()
}
