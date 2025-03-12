//
//  NetworkClientProtocol.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?
    ) async throws -> T
}
