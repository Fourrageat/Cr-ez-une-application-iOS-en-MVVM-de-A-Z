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
    
    static let defaultCandidates: [Candidate] = [
        Candidate(id: UUID(), firstName: "Alice", lastName: "Martin", isFavorite: true, phone: nil, email: "a@a.com", note: nil, linkedinURL: nil),
        Candidate(id: UUID(), firstName: "Bob", lastName: "Durand", isFavorite: false, phone: nil, email: "b@b.com", note: nil, linkedinURL: nil),
        Candidate(id: UUID(), firstName: "Chloe", lastName: "Bernard", isFavorite: false, phone: nil, email: "c@c.com", note: nil, linkedinURL: nil)
    ]

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
    var fetchCandidatesResult: [Candidate] = MockRepository.defaultCandidates
    var fetchCandidatesError: Error = NSError(domain: "Candidate", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])

    // Fetch single candidate
    var fetchCandidateShouldSucceed: Bool = true
    var fetchCandidateResult: Candidate = MockRepository.defaultCandidates.first!
    var fetchCandidateError: Error = NSError(domain: "Candidate", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found"])

    // Update candidate
    var updateCandidateShouldSucceed: Bool = true
    var updateCandidateResult: Candidate = MockRepository.defaultCandidates.first!
    var updateCandidateError: Error = NSError(domain: "Candidate", code: 400, userInfo: [NSLocalizedDescriptionKey: "Update failed"])

    // Delete candidate
    var deleteCandidateShouldSucceed: Bool = true
    var deleteCandidateError: Error = NSError(domain: "Candidate", code: 400, userInfo: [NSLocalizedDescriptionKey: "Delete failed"])

    // Update favorite
    var updateFavoriteShouldSucceed: Bool = true
    var updateFavoriteResult: Candidate = MockRepository.defaultCandidates.first!
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
            // Try to find and update in the list result first
            if let idx = fetchCandidatesResult.firstIndex(where: { $0.id.uuidString == id }) {
                var updated = fetchCandidatesResult[idx]
                updated.isFavorite.toggle()
                fetchCandidatesResult[idx] = updated

                // Keep single-candidate result coherent if it refers to the same candidate
                if fetchCandidateResult.id == updated.id {
                    fetchCandidateResult = updated
                }

                // Update the last returned favorite result for consistency
                updateFavoriteResult = updated
                return updated
            }

            // Fallback: if not in the list, try updating the single-candidate result
            if fetchCandidateResult.id.uuidString == id {
                var updated = fetchCandidateResult
                updated.isFavorite.toggle()
                fetchCandidateResult = updated
                updateFavoriteResult = updated
                return updated
            }

            // If nothing matched by id, just return a toggled copy of updateFavoriteResult
            var updated = updateFavoriteResult
            updated.isFavorite.toggle()
            updateFavoriteResult = updated
            return updated
        } else {
            throw updateFavoriteError
        }
    }
}

