import Foundation
import Testing
@testable import Vitesse


// Assuming a view model named CandidatesListViewModel with API as used in CandidatesListView.
@Suite("CandidatesListViewModel tests")
@MainActor
struct CandidatesListViewModelTests {
    @Test("Initial state is empty and not editing")
    func initialState() async throws {
        let mockRepository = MockRepository()
        let sut = CandidatesListViewModel(repository: mockRepository)
        #expect(sut.candidates.isEmpty)
        #expect(sut.search.isEmpty)
        #expect(sut.isEditing == false)
        #expect(sut.selectedIDs.isEmpty)
        #expect(sut.showFavoritesOnly == false)
    }

    @Test("Success: allCandidates and candidates are populated")
    func getCandidates_success_populates() async throws {

        let mockRepository = MockRepository()
        let sut = CandidatesListViewModel(repository: mockRepository)
        
        try await sut.getCandidates()

        #expect(sut.allCandidates.count == 3)
        #expect(sut.candidates.count == 3)
    }

    @Test("Fetch failure leaves list empty and may set an error state")
    func failedFetch() async throws {
        
        let mockRepository = MockRepository()
        mockRepository.fetchCandidatesShouldSucceed = false
        let sut = CandidatesListViewModel(repository: mockRepository)
        
        try await sut.getCandidates()
        
        #expect(sut.candidates.isEmpty)
        #expect(sut.allCandidates.isEmpty)
    }

    @Test("Search filters by first or last name, case-insensitive")
    func searchFilters() async throws {
        
        let mockRepository = MockRepository()
        let sut = CandidatesListViewModel(repository: mockRepository)
        
        sut.allCandidates = MockRepository.defaultCandidates

        sut.searchFilter("ali")
        #expect(sut.candidates.count == 1)
        #expect(sut.candidates.first?.firstName == "Alice")

        sut.searchFilter("ard")
        #expect(sut.candidates.count == 1)
        #expect(sut.candidates.first?.lastName == "Bernard")

        sut.searchFilter("")
        #expect(sut.candidates.count == 3)
    }

    @Test("Favorites filter toggles correctly")
    func favoritesFilter() async throws {
        
        let mockRepository = MockRepository()
        let sut = CandidatesListViewModel(repository: mockRepository)

        sut.allCandidates = MockRepository.defaultCandidates

        sut.toggleFavoritesOnly()
        #expect(sut.candidates.count == 1)
        #expect(sut.candidates.first?.firstName == "Alice")

        sut.toggleFavoritesOnly()
        #expect(sut.candidates.count == 3)
    }

    @Test("Editing mode toggles selection and deleteSelected calls repository")
    func editingAndDelete() async throws {
        
        let mockRepository = MockRepository()
        let sut = CandidatesListViewModel(repository: mockRepository)

        let list = MockRepository.defaultCandidates
        sut.allCandidates = list
        sut.applyFilters()

        // Enter editing and select first
        sut.isEditing = true
        #expect(sut.selectedIDs.count == 0)
        sut.toggleSelection(for: list.first!)
        #expect(sut.selectedIDs.count == 1)
        
        try await sut.deleteSelected()
        #expect(sut.selectedIDs.isEmpty)
    }
}

