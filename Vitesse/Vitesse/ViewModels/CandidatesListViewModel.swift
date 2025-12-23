import Combine
import Foundation

final class CandidatesListViewModel: ObservableObject {
    @Published var candidates: [Candidate]
    @Published var search: String = ""
    @Published var isEditing: Bool = false
    @Published var selectedIDs: Set<UUID> = []
    @Published var showFavoritesOnly: Bool = false
    
    let repository: RepositoryProtocol = Repository()
    
    private var allCandidates: [Candidate]
    
    init(candidates: [Candidate] = []) {
        self.candidates = candidates
        self.allCandidates = candidates
    }
    
    func getCandidates() async throws {
        do {
            let response = try await repository.fetchCandidates()
            candidates = response
            allCandidates = response
        } catch {
            print("Failed to fetch candidates: \(error)")
        }
    }
    
    func applyFilters() {
        var result: [Candidate] = allCandidates
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        candidates = result
    }
    
    func searchFilter(_ text: String) {

        let base = showFavoritesOnly ? allCandidates.filter { $0.isFavorite } : allCandidates

        guard !search.isEmpty else {
            candidates = base
            return
        }
        
        let query = text.lowercased()
        var result: [Candidate] = allCandidates.filter { candidate in
            let first = candidate.firstName.lowercased()
            let last = candidate.lastName.lowercased()

            return first.contains(query) || last.contains(query)
        }

        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }

        candidates = result
    }
    
    func toggleSelection(for candidate: Candidate) {
        if selectedIDs.contains(candidate.id) {
            selectedIDs.remove(candidate.id)
        } else {
            selectedIDs.insert(candidate.id)
        }
    }
    
    func deleteSelected() {
        guard !selectedIDs.isEmpty else { return }
        candidates.removeAll { selectedIDs.contains($0.id) }
        selectedIDs.removeAll()
    }
    
    func endEditing() {
        isEditing = false
        selectedIDs.removeAll()
    }
}
