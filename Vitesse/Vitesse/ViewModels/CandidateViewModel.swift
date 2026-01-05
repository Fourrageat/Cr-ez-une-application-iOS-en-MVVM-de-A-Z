//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 20/12/2025.
//

import SwiftUI
import Foundation
import Combine

@MainActor
final class CandidateViewModel: ObservableObject {

    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }
    
    @Published var candidate: Candidate
    @Published var isEditing: Bool = false
    @Published var candidateFirstName: String = ""
    @Published var candidateLastName: String = ""
    @Published var candidateEmail: String = ""
    @Published var candidatePhone: String = ""
    @Published var candidateLinkedinURL: String = ""
    @Published var candidateNote: String = ""
    @Published var loadState: LoadState = .idle
    @Published var lastError: String? = nil

    private let repository: RepositoryProtocol

    init(repository: RepositoryProtocol) {
        self.repository = repository
        self.candidate = Candidate(id: UUID(), firstName: "", lastName: "", phone: nil, email: "", note: nil, linkedinURL: nil)
        self.candidateFirstName = ""
        self.candidateLastName = ""
        self.candidateEmail = ""
        self.candidatePhone = ""
        self.candidateLinkedinURL = ""
        self.candidateNote = ""
        self.loadState = .idle
        self.lastError = nil
    }

    @MainActor
    convenience init() {
        self.init(repository: Repository())
    }

    convenience init(candidateId: UUID, repository: RepositoryProtocol) {
        self.init(repository: repository)
        load(candidateId: candidateId)
    }

    func fetchCandidate(candidateId: UUID) async throws {
        loadState = .loading
        lastError = nil
        do {
            let candidateResponse = try await repository.fetchCandidate(id: candidateId.uuidString)
            // Assign all published properties on the main actor (we already are on MainActor)
            self.candidate = candidateResponse
            self.candidateFirstName = candidateResponse.firstName
            self.candidateLastName = candidateResponse.lastName
            self.candidateEmail = candidateResponse.email
            self.candidatePhone = candidateResponse.phone ?? ""
            self.candidateLinkedinURL = candidateResponse.linkedinURL ?? ""
            self.candidateNote = candidateResponse.note ?? ""
            loadState = .loaded
        } catch {
            let message = (error as NSError).localizedDescription
            self.lastError = message
            loadState = .failed(message)
            throw error
        }
    }

    func load(candidateId: UUID) {
        // Start a top-level Task on the main actor; self is a @MainActor class so captures are safe
        Task { [candidateId] in
            do {
                try await fetchCandidate(candidateId: candidateId)
            } catch {
                // Error already captured in lastError/loadState in fetchCandidate
            }
        }
    }

    func doneEditing() {
        isEditing = false
    }

    func cancelEditing() {
        Task { [candidateId = self.candidate.id] in
            do {
                try await self.fetchCandidate(candidateId: candidateId)
            } catch {
                // keep current fields but mark failure
            }
            self.isEditing = false
        }
    }
}

