import SwiftUI

public struct CandidatesList: View {
    let candidates: [Candidate]
    let toggleFavorite: (Candidate) -> Void

    init(candidates: [Candidate], toggleFavorite: @escaping (Candidate) -> Void) {
        self.candidates = candidates
        self.toggleFavorite = toggleFavorite
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 12, pinnedViews: []) {
                ForEach(candidates) { candidate in
                    NavigationLink(destination: CandidateView(candidate: candidate)) {
                        CandidateCard(candidate: candidate, toggle: toggleFavorite)
                            .padding(.horizontal)
                    }
                    .tint(.primary)
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
