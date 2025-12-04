import SwiftUI

public struct CandidatesList: View {
    let candidates: [Candidate]
    let toggleFavorite: (Candidate) -> Void
    let isEditing: Bool
    @Binding var selectedIDs: Set<UUID>
    let onSelect: (Candidate) -> Void

    init(candidates: [Candidate],
                toggleFavorite: @escaping (Candidate) -> Void,
                isEditing: Bool = false,
                selectedIDs: Binding<Set<UUID>> = .constant([]),
                onSelect: @escaping (Candidate) -> Void = { _ in }) {
        self.candidates = candidates
        self.toggleFavorite = toggleFavorite
        self.isEditing = isEditing
        self._selectedIDs = selectedIDs
        self.onSelect = onSelect
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 12, pinnedViews: []) {
                ForEach(candidates) { candidate in
                    HStack(spacing: 0) {
                        if isEditing {
                            Image(systemName: selectedIDs.contains(candidate.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedIDs.contains(candidate.id) ? Color.accentColor : Color.secondary)
                                .padding(.leading, 15)
                        }
                        
                        NavigationLink(destination: CandidateView(candidate: candidate)) {
                            CandidateCard(candidate: candidate, toggle: toggleFavorite)
                                .padding(.horizontal)
                                .allowsHitTesting(!isEditing)
                        }
                        .tint(.primary)
                        .disabled(isEditing)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isEditing { onSelect(candidate) }
                    }
                }
                .animation(.snappy, value: candidates)
            }
            .padding(.vertical, 8)
        }
    }
}

struct CandidatesListView_Previews: PreviewProvider {
    static var previews: some View {
        let samples: [Candidate] = [
            .init(firstName: "Alice", lastName: "Martin", isFavorite: true),
            .init(firstName: "Bob", lastName: "Durand"),
            .init(firstName: "Chloé", lastName: "Bernard"),
            .init(firstName: "David", lastName: "Moreau", isFavorite: true),
        ]

        return CandidatesList(candidates: samples, toggleFavorite: { _ in })
    }
}
