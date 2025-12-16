//
//  CandidatesListView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct CandidatesListView: View {
    @StateObject private var viewModel = CandidatesListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                content
                    .toolbar { toolbar }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        viewModel.applyFilters()
                    }
            }
        }
        .task {
            do {
                try await viewModel.getCandidates()
            } catch {
                // TODO: handle error (e.g., show an alert or log)
                print("Failed to get candidates: \(error)")
            }
        }
    }
    

    private var content: some View {
        VStack(spacing: 0) {
            SearchField(text: $viewModel.search)
                .onChange(of: viewModel.search) { newValue in
                    viewModel.searchFilter(newValue)
                }

            if viewModel.candidates.isEmpty {
                EmptyState()
            } else {
                VStack(spacing: 8) {

                    CandidatesList(
                        candidates: viewModel.candidates,
                        isEditing: viewModel.isEditing,
                        selectedIDs: $viewModel.selectedIDs,
                        onSelect: { candidate in
                            viewModel.toggleSelection(for: candidate)
                        }
                    )
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(viewModel.isEditing ? "Cancel" : "Edit") {
                viewModel.isEditing.toggle()
                if !viewModel.isEditing {
                    viewModel.selectedIDs.removeAll()
                }
            }
        }
        ToolbarItem(placement: .title) {
            Text("Candidates")
        }
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.isEditing {
                Button(role: .destructive) {
                    viewModel.deleteSelected()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(viewModel.selectedIDs.isEmpty)
            } else {
                Button {
                    viewModel.showFavoritesOnly.toggle()
                    viewModel.applyFilters()
                } label: {
                    Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                }
            }
        }
    }
}

#Preview {
    CandidatesListView()
}

//struct CandidatesView_Previews: PreviewProvider {
//    static var previews: some View {
//        let samples: [Candidate] = [
//            .init(firstName: "Alice", lastName: "Martin", isFavorite: true),
//            .init(firstName: "Bob", lastName: "Durand"),
//            .init(firstName: "Chloé", lastName: "Bernard"),
//            .init(firstName: "David", lastName: "Moreau", isFavorite: true),
//            .init(firstName: "Éva", lastName: "Lefèvre"),
//            .init(firstName: "Farid", lastName: "Rossi"),
//            .init(firstName: "Gaëlle", lastName: "Petit"),
//            .init(firstName: "Hugo", lastName: "Robert"),
//            .init(firstName: "Inès", lastName: "Richard"),
//            .init(firstName: "Jules", lastName: "Dubois")
//        ]
//
//        return CandidatesListView(candidates: samples)
//    }
//}
//

