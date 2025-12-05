import Combine
import Foundation

final class CandidatesListViewModel: ObservableObject {
    @Published var candidates: [Candidate]
    @Published var search: String = ""
    @Published var isEditing: Bool = false
    @Published var selectedIDs: Set<UUID> = []
    @Published var showFavoritesOnly: Bool = false
    
    private var allCandidates: [Candidate] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(candidates: [Candidate] = [
        .init(firstName: "Alice", lastName: "Martin",  isFavorite: true, phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Bob", lastName: "Durand", phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Chloé", lastName: "Bernard",  isFavorite: true, phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "David", lastName: "Moreau", phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Éva", lastName: "Lefèvre", phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Farid", lastName: "Rossi", phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Gaëlle", lastName: "Petit", phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Hugo", lastName: "Robert", phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Inès", lastName: "Richard", phone: "", email: "", note: "", linkedin: ""),
        .init(firstName: "Jules", lastName: "Dubois", phone: "", email: "", note: "", linkedin: "")
    ]) {
        self.candidates = candidates
        self.allCandidates = candidates
        
        Publishers.CombineLatest($search.removeDuplicates(), $showFavoritesOnly.removeDuplicates())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (search, favoritesOnly) in
                self?.applyFilters(search: search, favoritesOnly: favoritesOnly)
            }
            .store(in: &cancellables)
    }
    
    private func applyFilters(search: String, favoritesOnly: Bool) {
        var filtered = allCandidates

        if favoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }

        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            let query = trimmed.lowercased()
            filtered = filtered.filter { candidate in
                candidate.firstName.lowercased().contains(query)
                || candidate.lastName.lowercased().contains(query)
            }
        }

        candidates = filtered
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
        allCandidates.removeAll { selectedIDs.contains($0.id) }
        selectedIDs.removeAll()
        applyFilters(search: search, favoritesOnly: showFavoritesOnly)
    }
    
    func endEditing() {
        isEditing = false
        selectedIDs.removeAll()
    }
}

