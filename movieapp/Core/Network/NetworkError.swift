//
//  NetworkError.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case dataNotFound
    case decodingFailed(Error)
    case serverError(statusCode: Int)
    case unauthorized
    case unknown
    
    var description: String {
        switch self {
        case .invalidURL:
            return "La URL es inválida"
        case .requestFailed(let error):
            return "La solicitud falló: \(error.localizedDescription)"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .dataNotFound:
            return "No se encontraron datos"
        case .decodingFailed(let error):
            return "Error al decodificar los datos: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Error del servidor: código \(statusCode)"
        case .unauthorized:
            return "No autorizado para acceder a este recurso"
        case .unknown:
            return "Ocurrió un error desconocido"
        }
    }
}
