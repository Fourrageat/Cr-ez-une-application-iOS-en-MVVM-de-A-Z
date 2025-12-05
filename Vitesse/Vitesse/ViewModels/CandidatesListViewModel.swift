import Combine
import Foundation

final class CandidatesListViewModel: ObservableObject {
    @Published var candidates: [Candidate]
    @Published var search: String = ""
    @Published var isEditing: Bool = false
    @Published var selectedIDs: Set<UUID> = []
    @Published var showFavoritesOnly: Bool = false
    
    init(candidates: [Candidate] = []) {
        self.candidates = candidates
    }
    
    var filteredCandidates: [Candidate] {
        let base = showFavoritesOnly ? candidates.filter { $0.isFavorite } : candidates
        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return base }
        return base.filter { $0.displayName.localizedCaseInsensitiveContains(trimmed) }
    }
    
    func toggleFavorite(_ candidate: Candidate) {
        if let idx = candidates.firstIndex(of: candidate) {
            candidates[idx].isFavorite.toggle()
        }
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

