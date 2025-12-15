//
//  AuthenticationRepository.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 15/12/2025.
//

import Foundation

// MARK: - Models

struct AuthCredentials: Codable, Equatable {
    let email: String
    let password: String
}

struct AuthResponse: Codable, Equatable {
    let isAdmin: Bool
    let token: String
}

// MARK: - Protocol

protocol AuthenticationRepositoryProtocol {
    func login(with credentials: AuthCredentials) async throws -> AuthResponse
}

// MARK: - Repository

final class AuthenticationRepository: AuthenticationRepositoryProtocol {

    enum RepositoryError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case serverError(statusCode: Int)

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid URL"
            case .invalidResponse: return "Invalid server response"
            case .serverError(let status): return "Server error (status: \(status))"
            }
        }
    }

    private let baseURL: URL
    private let urlSession: URLSession

    init(baseURL: URL = URL(string: "http://127.0.0.1:8080")!, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    // POST /user/auth
    func login(with credentials: AuthCredentials) async throws -> AuthResponse {
        let url = baseURL.appending(path: "/user/anth")
        let request = try URLRequest(
            url: url,
            method: .POST,
            parameters: try toParameters(credentials),
            headers: ["Accept": "application/json"]
        )
        return try await perform(AuthResponse.self, request: request)
    }

    // MARK: - Networking helpers

    private func perform<T: Decodable>(_ type: T.Type = T.self, request: URLRequest) async throws -> T {
        let (data, response) = try await urlSession.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw RepositoryError.invalidResponse }
        guard 200..<300 ~= http.statusCode else { throw RepositoryError.serverError(statusCode: http.statusCode) }
        if T.self == EmptyDecodable.self { return EmptyDecodable() as! T }
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func toParameters<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try JSONEncoder().encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = json as? [String: Any] else { throw RepositoryError.invalidResponse }
        return dict
    }
}

// Helper to represent empty response bodies
private struct EmptyDecodable: Decodable {}

