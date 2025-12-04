//
//  CandidatsView.swift
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
            }
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            searchField
            if filteredCandidates.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(filteredCandidates) { candidate in
                        CandidateRow(candidate: candidate, toggle: toggleFavorite)
                            .listRowSeparator(.visible)
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Search", text: $search)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.search)
        }
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.3")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No candidates yet")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                
            }
        }
        ToolbarItem(placement: .title) {
            Text("Candidats")
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // Placeholder for future action
            } label: {
                Image(systemName: "star")
            }
        }
    }
}

private struct CandidateRow: View {
    var candidate: Candidate
    var toggle: (Candidate) -> Void

    var body: some View {
        HStack {
            Text(candidate.displayName)
                .font(.body)
            Spacer()
            Button {
                toggle(candidate)
            } label: {
                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(candidate.isFavorite ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview("Avec données factices") {
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

    CandidatesView(candidates: samples)
}
