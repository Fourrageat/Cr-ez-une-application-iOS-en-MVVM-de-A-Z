//
//  CandidatesView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct Candidate: Identifiable, Hashable {
    let id = UUID()
    var firstName: String
    var lastName: String
    var isFavorite: Bool = false

    var displayName: String { "\(firstName) \(lastName)" }
}

struct CandidatesView: View {
    // Runtime data: starts empty as requested
    @State private var candidates: [Candidate] = []
    @State private var search: String = ""
    @State private var goToEditableCandidatesListView: Bool = false
    @State private var goToFavoriteCandidatesView: Bool = false

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
                CandidatesListView(candidates: filteredCandidates, toggleFavorite: toggleFavorite)
            }
        }
        .navigationDestination(isPresented: $goToEditableCandidatesListView) {
            EditableCandidatesListView()
        }
        .navigationDestination(isPresented: $goToFavoriteCandidatesView) {
            FavoriteCandidatesView()
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

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Edit") {
                goToEditableCandidatesListView = true
            }
        }
        ToolbarItem(placement: .title) {
            Text("Candidates")
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                goToFavoriteCandidatesView = true
            } label: {
                Image(systemName: "star")
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

        return CandidatesView(candidates: samples)
    }
}

