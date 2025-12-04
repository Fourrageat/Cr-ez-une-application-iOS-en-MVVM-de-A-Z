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
                    .navigationBarBackButtonHidden(true)

            }
        }
        
    }

    private var content: some View {
        VStack(spacing: 0) {
            searchField

            if filteredCandidates.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 12, pinnedViews: []) {
                        ForEach(filteredCandidates) { candidate in
                            NavigationLink(destination: CandidateDetailView(candidate: candidate)) {
                                CandidateCard(candidate: candidate, toggle: toggleFavorite)
                                    .padding(.horizontal)
                            }
                            .tint(.primary)
                            
                        }
                        .animation(.snappy, value: filteredCandidates)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationDestination(isPresented: $goToEditableCandidatesListView) {
            EditableCandidatesListView()
        }
        .navigationDestination(isPresented: $goToFavoriteCandidatesView) {
            FavoriteCandidatesView()
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                .padding(.leading, 8)
            TextField("Search", text: $search)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.search)
        }
        .padding(.vertical, 14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal)
        .padding(.vertical, 10)
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

private struct CandidateCard: View {
    var candidate: Candidate
    var toggle: (Candidate) -> Void

    var initials: String {
        let f = candidate.firstName.first.map { String($0) } ?? ""
        let l = candidate.lastName.first.map { String($0) } ?? ""
        return (f + l).uppercased()
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.quaternary)
                Text(initials)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 36, height: 36)

            HStack(spacing: 2) {
                Text(candidate.firstName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("\(candidate.lastName.first.map { String($0) } ?? "").")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(.leading, 4)
            }

            Spacer(minLength: 8)

            Button {
                withAnimation(.spring(duration: 0.25)) {
                    toggle(candidate)
                }
            } label: {
                if #available(iOS 17.0, *) {
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .symbolEffect(.bounce, value: candidate.isFavorite)
                        .foregroundStyle(candidate.isFavorite ? .yellow : .secondary)
                } else {
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(candidate.isFavorite ? .yellow : .secondary)
                }
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            Group {
                if #available(iOS 17.0, *) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.separator.opacity(0.4))
                } else {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.secondary.opacity(0.25))
                }
            }
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .hoverEffect(.highlight)
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
