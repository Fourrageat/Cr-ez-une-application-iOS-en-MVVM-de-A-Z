import SwiftUI

public struct CandidatesList: View {
    let candidates: [Candidate]
    let isEditing: Bool
    @Binding var selectedIDs: Set<UUID>
    let onSelect: (Candidate) -> Void

    init(candidates: [Candidate],
                isEditing: Bool = false,
                selectedIDs: Binding<Set<UUID>> = .constant([]),
                onSelect: @escaping (Candidate) -> Void = { _ in }) {
        self.candidates = candidates
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
                            CandidateCard(candidate: candidate)
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
            .init(firstName: "Alice", lastName: "Martin", isFavorite: true, phone: "+33 1 23 45 67 89", email: "alice.martin@example.com", note: "Senior iOS Engineer", linkedin: "https://www.linkedin.com/in/alicemartin"),
            .init(firstName: "Bob", lastName: "Durand", phone: "+33 6 11 22 33 44", email: "bob.durand@example.com", note: "Backend Developer", linkedin: "https://www.linkedin.com/in/bobdurand"),
            .init(firstName: "Chloé", lastName: "Bernard", phone: "+33 7 55 66 77 88", email: "chloe.bernard@example.com", note: "Data Scientist", linkedin: "https://www.linkedin.com/in/chloebernard"),
            .init(firstName: "David", lastName: "Moreau", isFavorite: true, phone: "+33 1 98 76 54 32", email: "david.moreau@example.com", note: "Product Manager", linkedin: "https://www.linkedin.com/in/davidmoreau"),
        ]

        return CandidatesList(candidates: samples)
    }
}
