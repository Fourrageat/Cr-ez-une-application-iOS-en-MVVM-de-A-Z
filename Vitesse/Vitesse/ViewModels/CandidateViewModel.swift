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
    @Published var isAdmin: Bool = UserDefaults.standard.bool(forKey: "is_admin")
    
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
        Task { [candidateId] in
            do {
                try await fetchCandidate(candidateId: candidateId)
            } catch {
                print("Error fetching candidate: \(error)")
            }
        }
    }

    func doneEditing() async {
        isEditing = false
        do {
            let updatedCandidate = try await repository.updateCandidate(
                id: candidate.id.uuidString,
                firstName: candidateFirstName,
                lastName: candidateLastName,
                phone: candidatePhone,
                email: candidateEmail,
                note: candidateNote,
                linkedinURL: candidateLinkedinURL
            )
            self.candidate = updatedCandidate
            self.candidateFirstName = updatedCandidate.firstName
            self.candidateLastName = updatedCandidate.lastName
            self.candidateEmail = updatedCandidate.email
            self.candidatePhone = updatedCandidate.phone ?? ""
            self.candidateLinkedinURL = updatedCandidate.linkedinURL ?? ""
            self.candidateNote = updatedCandidate.note ?? ""
            
            loadState = .loaded
            lastError = nil
        } catch {
            let message = (error as NSError).localizedDescription
            lastError = message
            loadState = .failed(message)
        }
    }

    func cancelEditing() async {
        do {
            try await self.fetchCandidate(candidateId: self.candidate.id)
        } catch {
            print("Error cancelling: \(error)")
        }
        self.isEditing = false
    }
    
    func toogleFavorite() async {
        do {
            _ = try await repository.updateFavoriteCandidate(id: candidate.id.uuidString)
            try await self.fetchCandidate(candidateId: self.candidate.id)
            lastError = nil
        } catch {
            let message = (error as NSError).localizedDescription
            lastError = message
            loadState = .failed(message)
            print("Error toggling favorite: \(message)")
        }
    }
}

