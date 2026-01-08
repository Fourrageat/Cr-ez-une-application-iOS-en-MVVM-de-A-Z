import Testing
import Foundation
@testable import Vitesse

@Suite("CandidateViewModel tests")
@MainActor
struct CandidateViewModelTests {
    @Test("Success: populate candidate informations")
    func getCandidates_success_populates() async throws {

        let candidateID = MockRepository.defaultCandidates.first!.id
        let mockRepository = MockRepository()

        let sut = CandidateViewModel(repository: mockRepository)

        await sut.load(candidateId: candidateID)

        if sut.candidate.firstName.isEmpty {
            let start = Date()
            while sut.candidate.firstName.isEmpty && Date().timeIntervalSince(start) < 1.0 {
                try await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
        }

        #expect(sut.candidate.firstName == "Alice")
        #expect(sut.candidate.lastName == "Martin")
        #expect(sut.candidate.email == "a@a.com")
    }
    
    @Test("Failure: populate candidate informations")
    func getCandidates_fail_populates() async throws {

        let candidateID = MockRepository.defaultCandidates.first!.id
        let mockRepository = MockRepository()
        mockRepository.fetchCandidateShouldSucceed = false
            
        let sut = CandidateViewModel(repository: mockRepository)

        await sut.load(candidateId: candidateID)

        #expect(sut.candidate.firstName.isEmpty)
        #expect(sut.candidate.lastName.isEmpty)
        #expect(sut.candidate.email.isEmpty)
    }
    
    @Test("Success: update candidate informations")
    func updateCandidate_success() async throws {
        let mockRepository = MockRepository()
        let sut = CandidateViewModel(repository: mockRepository)
        
        let candidate = MockRepository.defaultCandidates.first!
        await sut.load(candidateId: candidate.id)
        
        if sut.candidate.firstName.isEmpty {
            let start = Date()
            while sut.candidate.firstName.isEmpty && Date().timeIntervalSince(start) < 1.0 {
                try await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
        }
        
        sut.candidateFirstName = "Fredo"
        sut.candidateLastName = "Lang"
        
        await sut.doneEditing()

        #expect(sut.candidate.firstName == "Fredo")
        #expect(sut.candidate.lastName == "Lang")
        #expect(sut.candidate.email == candidate.email)
    }
    
    @Test("Failure: update candidate informations")
    func updateCandidate_fail() async throws {
        let mockRepository = MockRepository()
        let sut = CandidateViewModel(repository: mockRepository)
        mockRepository.updateCandidateShouldSucceed = false
        
        let candidate = MockRepository.defaultCandidates.first!
        await sut.load(candidateId: candidate.id)
        
        if sut.candidate.firstName.isEmpty {
            let start = Date()
            while sut.candidate.firstName.isEmpty && Date().timeIntervalSince(start) < 1.0 {
                try await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
        }
        
        sut.candidateFirstName = "Fredo"
        sut.candidateLastName = "Lang"
        
        await sut.doneEditing()

        #expect(sut.candidate.firstName == "Alice")
        #expect(sut.candidate.lastName == "Martin")
    }
    
    @Test("Success: cancel editing")
    func cancelEditing_success() async throws {
        let mockRepository = MockRepository()
        let sut = CandidateViewModel(repository: mockRepository)
        
        let candidate = MockRepository.defaultCandidates.first!
        await sut.load(candidateId: candidate.id)
        
        if sut.candidate.firstName.isEmpty {
            let start = Date()
            while sut.candidate.firstName.isEmpty && Date().timeIntervalSince(start) < 1.0 {
                try await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
        }
        
        sut.isEditing.toggle()
        
        sut.candidateFirstName = "Fredo"
        sut.candidateLastName = "Lang"
        
        await sut.cancelEditing()
        
        #expect(sut.candidate.firstName == candidate.firstName)
        #expect(sut.candidate.lastName == candidate.lastName)
    }
    
    @Test("Success: toogle favorite")
    func toogleFavorite_success() async throws {
        let mockRepository = MockRepository()
        let sut = CandidateViewModel(repository: mockRepository)
        
        let candidate = MockRepository.defaultCandidates.first!
        await sut.load(candidateId: candidate.id)
        
        if sut.candidate.firstName.isEmpty {
            let start = Date()
            while sut.candidate.firstName.isEmpty && Date().timeIntervalSince(start) < 1.0 {
                try await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
        }
        
        let isFavorite = sut.candidate.isFavorite
        
        await sut.toogleFavorite()
        
        #expect(sut.candidate.isFavorite != isFavorite)
    }
    
    @Test("Failure: toogle favorite")
    func toogleFavorite_fail() async throws {
        let mockRepository = MockRepository()
        let sut = CandidateViewModel(repository: mockRepository)
        mockRepository.updateFavoriteShouldSucceed = false
        
        let candidate = MockRepository.defaultCandidates.first!
        await sut.load(candidateId: candidate.id)
        
        if sut.candidate.firstName.isEmpty {
            let start = Date()
            while sut.candidate.firstName.isEmpty && Date().timeIntervalSince(start) < 1.0 {
                try await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
        }
        
        let isFavorite = sut.candidate.isFavorite
        
        await sut.toogleFavorite()
        
        #expect(sut.candidate.isFavorite == isFavorite)
    }
}

