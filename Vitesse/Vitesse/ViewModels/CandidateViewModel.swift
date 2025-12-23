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
    
    @Published var candidate: Candidate
    @Published var isEditing: Bool = false
    @Published var candidateFirstName: String = ""
    @Published var candidateLastName: String = ""
    @Published var candidateEmail: String = ""
    @Published var candidatePhone: String = ""
    @Published var candidateLinkedinURL: String = ""
    @Published var candidateNote: String = ""

    private let repository: RepositoryProtocol

    init() {
        self.repository = Repository()
        self.candidate = Candidate(id: UUID(), firstName: "", lastName: "", phone: nil, email: "", note: nil, linkedinURL: nil)
        self.candidateFirstName = ""
        self.candidateLastName = ""
        self.candidateEmail = ""
        self.candidatePhone = ""
        self.candidateLinkedinURL = ""
        self.candidateNote = ""
    }

    convenience init(candidateId: UUID) {
        self.init()
        Task { [weak self] in
            guard let self else { return }
            try? await self.fetchCandidate(candidateId: candidateId)
        }
    }

    func fetchCandidate(candidateId: UUID) async throws {
        let candidateResponse = try await repository.fetchCandidate(id: candidateId.uuidString)
        self.candidate = candidateResponse
        self.candidateFirstName = candidateResponse.firstName
        self.candidateLastName = candidateResponse.lastName
        self.candidateEmail = candidateResponse.email
        self.candidatePhone = candidateResponse.phone ?? ""
        self.candidateLinkedinURL = candidateResponse.linkedinURL ?? ""
        self.candidateNote = candidateResponse.note ?? ""
    }

    func load(candidateId: UUID) {
        Task { [weak self] in
            guard let self else { return }
            try? await self.fetchCandidate(candidateId: candidateId)
        }
    }

    func doneEditing() {
        isEditing = false
    }

    func cancelEditing() {
        Task { [weak self] in
            guard let self else { return }
            try? await self.fetchCandidate(candidateId: self.candidate.id)
            self.isEditing = false
        }
    }
}

