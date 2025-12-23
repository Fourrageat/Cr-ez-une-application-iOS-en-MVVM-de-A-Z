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
            allCandidates = response
            applyFilters()
        } catch {
            print("Failed to fetch candidates: \(error)")
        }
    }
    
    func applyFilters() {
        // Start from the full dataset
        var result = allCandidates

        // Apply favorites filter if needed
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }

        // Apply search filter if needed
        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            let query = trimmed.lowercased()
            result = result.filter { candidate in
                let first = candidate.firstName.lowercased()
                let last = candidate.lastName.lowercased()
                return first.contains(query) || last.contains(query)
            }
        }

        // Publish
        candidates = result
    }
    
    func toggleFavoritesOnly() {
        showFavoritesOnly.toggle()
        applyFilters()
    }
    
    func searchFilter(_ text: String) {
        // Update stored search text and re-apply combined filters
        self.search = text
        applyFilters()
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
