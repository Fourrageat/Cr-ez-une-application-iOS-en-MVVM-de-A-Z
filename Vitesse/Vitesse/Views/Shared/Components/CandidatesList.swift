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

        return Group {
            ZStack {
                AppBackground()
                CandidatesList(candidates: Samples.candidates)
            }
        }
    }
}
