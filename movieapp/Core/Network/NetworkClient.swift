//
//  NetworkClient.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

actor NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Establecer headers por defecto
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Añadir headers personalizados
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingFailed(error)
                }
            case 401:
                throw NetworkError.unauthorized
            case 400...499:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            case 500...599:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw NetworkError.unknown
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
