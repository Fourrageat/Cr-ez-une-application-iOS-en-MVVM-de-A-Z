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
    @Published var editedPhone: String = ""
    @Published var editedEmail: String = ""
    @Published var editedLinkedinURL: String = ""
    @Published var editedNote: String = ""
    
    let repository: RepositoryProtocol = Repository()

    init(candidate: Candidate) {
        self.candidate = candidate
    }

    func loadCandidateId() async throws {

        do {
            try await candidate = repository.fetchCandidate(id: candidate.id.uuidString)
            print(candidate)
        } catch {
            
        }
        
        editedPhone = candidate.phone ?? ""
        editedEmail = candidate.email
        editedLinkedinURL = candidate.linkedinURL ?? ""
        editedNote = candidate.note ?? ""
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
        try await loadCandidateId()
        isEditing = false
    }
}

