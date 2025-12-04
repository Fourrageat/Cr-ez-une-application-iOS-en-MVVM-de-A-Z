//
//  CandidatesListView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct CandidatesListView: View {
    // Runtime data: starts empty as requested
    @State private var candidates: [Candidate] = []
    @State private var search: String = ""
    @State private var isEditing: Bool = false
    @State private var selectedIDs: Set<UUID> = []

    // Initializer to inject initial candidates (useful for previews)
    init(candidates: [Candidate] = []) {
        _candidates = State(initialValue: candidates)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                content
                    .toolbar { toolbar }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
            }
        }
        
    }

    private var content: some View {
        VStack(spacing: 0) {
            SearchField(text: $search)

            if filteredCandidates.isEmpty {
                EmptyState()
            } else {
                VStack(spacing: 8) {

                    CandidatesList(
                        candidates: filteredCandidates,
                        toggleFavorite: { candidate in
                            toggleFavorite(candidate)
                        },
                        isEditing: isEditing,
                        selectedIDs: $selectedIDs,
                        onSelect: { candidate in
                            toggleSelection(for: candidate)
                        }
                    )
                }
            }
        }
    }

    private var filteredCandidates: [Candidate] {
        guard !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return candidates }
        return candidates.filter { $0.displayName.localizedCaseInsensitiveContains(search) }
    }

    private func toggleFavorite(_ candidate: Candidate) {
        if let idx = candidates.firstIndex(of: candidate) {
            candidates[idx].isFavorite.toggle()
        }
    }

    private func toggleSelection(for candidate: Candidate) {
        if selectedIDs.contains(candidate.id) {
            selectedIDs.remove(candidate.id)
        } else {
            selectedIDs.insert(candidate.id)
        }
    }

    private func deleteSelected() {
        guard !selectedIDs.isEmpty else { return }
        candidates.removeAll { selectedIDs.contains($0.id) }
        selectedIDs.removeAll()
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(isEditing ? "Done" : "Edit") {
                isEditing.toggle()
                if !isEditing {
                    selectedIDs.removeAll()
                }
            }
        }
        ToolbarItem(placement: .title) {
            Text("Candidates")
        }
        ToolbarItem(placement: .topBarTrailing) {
            if isEditing {
                Button(role: .destructive) {
                    deleteSelected()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selectedIDs.isEmpty)
            } else {
                Button {
                    
                } label: {
                    Image(systemName: "star")
                }
            }
        }
    }
}



struct CandidatesView_Previews: PreviewProvider {
    static var previews: some View {
        let samples: [Candidate] = [
            .init(firstName: "Alice", lastName: "Martin", isFavorite: true),
            .init(firstName: "Bob", lastName: "Durand"),
            .init(firstName: "Chloé", lastName: "Bernard"),
            .init(firstName: "David", lastName: "Moreau", isFavorite: true),
            .init(firstName: "Éva", lastName: "Lefèvre"),
            .init(firstName: "Farid", lastName: "Rossi"),
            .init(firstName: "Gaëlle", lastName: "Petit"),
            .init(firstName: "Hugo", lastName: "Robert"),
            .init(firstName: "Inès", lastName: "Richard"),
            .init(firstName: "Jules", lastName: "Dubois")
        ]

        return CandidatesListView(candidates: samples)
    }
}

