//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 20/12/2025.
//

import SwiftUI
import Foundation
import Combine

final class CandidateViewModel: ObservableObject {
    
    @Published var candidate: Candidate
    @Published var isEditing: Bool = false
    @Published var candidateFirstName: String = ""
    @Published var candidateLastName: String = ""
    @Published var candidateEmail: String = ""
    @Published var candidatePhone: String = ""
    @Published var candidateLinkedinURL: String = ""
    @Published var candidateNote: String = ""

    let repository: RepositoryProtocol

    init(candidateId: UUID) {
        self.repository = Repository()
        self.candidate = Candidate(id: candidateId, firstName: "", lastName: "", phone: nil, email: "", note: nil, linkedinURL: nil)
        self.candidateFirstName = ""
        self.candidateLastName = ""
        self.candidateEmail = ""
        self.candidatePhone = ""
        self.candidateLinkedinURL = ""
        self.candidateNote = ""
    }

    @MainActor
    func fetchCandidate(candidateId: UUID) async {
        do {
            let candidateResponse = try await repository.fetchCandidate(id: candidateId.uuidString)
            self.candidate = candidateResponse
            self.candidateFirstName = candidateResponse.firstName
            self.candidateLastName = candidateResponse.lastName
            self.candidateEmail = candidateResponse.email
            self.candidatePhone = candidateResponse.phone ?? ""
            self.candidateLinkedinURL = candidateResponse.linkedinURL ?? ""
            self.candidateNote = candidateResponse.note ?? ""
            print(candidate)
        } catch {
            print("Error fetching candidate: \(error)")
        }
    }

    func toggleEditing() {
        isEditing.toggle()
    }

    func startEditing() {
        isEditing = true
    }

    func doneEditing() {
        isEditing = false
    }

    func cancelEditing() async throws {
        try await fetchCandidate(candidateId: candidate.id)
        isEditing = false
    }
}
