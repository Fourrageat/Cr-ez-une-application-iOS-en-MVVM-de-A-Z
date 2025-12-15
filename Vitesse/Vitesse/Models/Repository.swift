//
//  Repository.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 15/12/2025.
//

import Foundation

// MARK: - Models

// Login
private struct Credentials: Encodable {
    let email: String
    let password: String
}

struct AuthResponse: Codable, Equatable {
    let isAdmin: Bool
    let token: String
}

// Register
private struct User: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}

// Candidate
struct Candidate: Identifiable, Hashable, Codable {
    var id = UUID()
    let firstName: String
    let lastName: String
    var isFavorite: Bool = false
    let phone: String?
    let email: String
    let note: String?
    let linkedin: String?
}

struct Candidates: Codable {
    let candidates: [Candidate]
}


// MARK: - Protocol

protocol RepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String, firstName: String, lastName: String) async throws -> Void
    func fetchCandidates() async throws -> Candidates
}

// MARK: - Repository

final class Repository: RepositoryProtocol {

    enum RepositoryError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case serverError(statusCode: Int)

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid URL"
            case .invalidResponse: return "Invalid server response"
            case .serverError(let status): return status.description
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
    func login(email: String, password: String) async throws -> AuthResponse {
        let url = baseURL.appending(path: "/user/auth")
        let request = try URLRequest(
            url: url,
            method: .POST,
            parameters: try toParameters(Credentials(email: email, password: password)),
            headers: ["Accept": "application/json", "Content-Type": "application/json"]
        )
        return try await perform(AuthResponse.self, request: request)
    }
    
    // POST /user/register
    func register(email: String, password: String, firstName: String, lastName: String) async throws -> Void {
        let url = baseURL.appending(path: "/user/register")
        let request = try URLRequest(
            url: url,
            method: .POST,
            parameters: try toParameters(User(email: email, password: password, firstName: firstName, lastName: lastName)),
            headers: ["Accept": "application/json", "Content-Type": "application/json"]
        )
        _ = try await perform(EmptyDecodable.self, request: request)
    }
    
    // GET /candidate
    func fetchCandidates() async throws -> Candidates {
        let url = baseURL.appending(path: "/candidate")
        let request = try URLRequest(
            url: url,
            method: .GET,
            parameters: nil,
            headers: ["Accept": "application/json", "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token")!)"]
        )
        return try await perform(Candidates.self, request: request)
    }
    
    // GET /candidate/:candidateid
    func fetchCandidate(id: String) async throws -> Candidate {
        let url = baseURL.appending(path: "/candidate/\(id)")
        let request = try URLRequest(
            url: url,
            method: .GET,
            parameters: nil,
            headers: ["Accept": "application/json", "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token")!)"]
        )
        return try await perform(Candidate.self, request: request)
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

