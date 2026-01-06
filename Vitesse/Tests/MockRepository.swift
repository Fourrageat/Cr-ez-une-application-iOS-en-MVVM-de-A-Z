//
//  MockRepository.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 06/01/2026.
//

import Foundation
@testable import Vitesse
/// Mock implementation of RepositoryProtocol to be used in tests.
/// You can control each API call outcome by toggling the corresponding flags
/// and setting the returned values below.
final class MockRepository: RepositoryProtocol {
    // MARK: - Scenario controls
    // Login
    var loginShouldSucceed: Bool = true
    var loginReturnedToken: String = "token_123"
    var loginReturnedIsAdmin: Bool = false
    var loginError: Error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Bad credentials"])    

    // Register
    var registerShouldSucceed: Bool = true
    var registerError: Error = NSError(domain: "Register", code: 400, userInfo: [NSLocalizedDescriptionKey: "Register failed"])    

    // Fetch candidates (list)
    var fetchCandidatesShouldSucceed: Bool = true
    var fetchCandidatesResult: [Candidate] = []
    var fetchCandidatesError: Error = NSError(domain: "Candidate", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])    

    // Fetch single candidate
    var fetchCandidateShouldSucceed: Bool = true
    var fetchCandidateResult: Candidate = Candidate(id: UUID(), firstName: "John", lastName: "Doe", phone: nil, email: "john.doe@example.com", note: nil, linkedinURL: nil)
    var fetchCandidateError: Error = NSError(domain: "Candidate", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found"])    

    // Update candidate
    var updateCandidateShouldSucceed: Bool = true
    var updateCandidateResult: Candidate = Candidate(id: UUID(), firstName: "John", lastName: "Doe", phone: "0000000000", email: "john.doe@example.com", note: "", linkedinURL: "")
    var updateCandidateError: Error = NSError(domain: "Candidate", code: 400, userInfo: [NSLocalizedDescriptionKey: "Update failed"])    

    // Delete candidate
    var deleteCandidateShouldSucceed: Bool = true
    var deleteCandidateError: Error = NSError(domain: "Candidate", code: 400, userInfo: [NSLocalizedDescriptionKey: "Delete failed"])    

    // Update favorite
    var updateFavoriteShouldSucceed: Bool = true
    var updateFavoriteResult: Candidate = Candidate(id: UUID(), firstName: "John", lastName: "Doe", isFavorite: true, phone: nil, email: "john.doe@example.com", note: nil, linkedinURL: nil)
    var updateFavoriteError: Error = NSError(domain: "Candidate", code: 400, userInfo: [NSLocalizedDescriptionKey: "Favorite failed"])    

    // MARK: - RepositoryProtocol

    func login(email: String, password: String) async throws -> AuthResponse {
        if loginShouldSucceed {
            return AuthResponse(isAdmin: loginReturnedIsAdmin, token: loginReturnedToken)
        } else {
            throw loginError
        }
    }

    func register(email: String, password: String, firstName: String, lastName: String) async throws {
        if registerShouldSucceed {
            return
        } else {
            throw registerError
        }
    }

    func fetchCandidates() async throws -> [Candidate] {
        if fetchCandidatesShouldSucceed {
            return fetchCandidatesResult
        } else {
            throw fetchCandidatesError
        }
    }

    func fetchCandidate(id: String) async throws -> Candidate {
        if fetchCandidateShouldSucceed {
            return fetchCandidateResult
        } else {
            throw fetchCandidateError
        }
    }

    func updateCandidate(
        id: String,
        firstName: String,
        lastName: String,
        phone: String?,
        email: String,
        note: String?,
        linkedinURL: String?
    ) async throws -> Candidate {
        if updateCandidateShouldSucceed {
            // Return a candidate reflecting the inputs to make assertions easier
            return Candidate(
                id: updateCandidateResult.id,
                firstName: firstName,
                lastName: lastName,
                isFavorite: updateCandidateResult.isFavorite,
                phone: phone,
                email: email,
                note: note,
                linkedinURL: linkedinURL
            )
        } else {
            throw updateCandidateError
        }
    }

    func deleteCandidate(id: String) async throws {
        if deleteCandidateShouldSucceed {
            return
        } else {
            throw deleteCandidateError
        }
    }

    func updateFavoriteCandidate(id: String) async throws -> Candidate {
        if updateFavoriteShouldSucceed {
            return updateFavoriteResult
        } else {
            throw updateFavoriteError
        }
    }
}

