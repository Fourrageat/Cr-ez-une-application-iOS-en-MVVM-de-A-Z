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
            }
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            SearchField(text: $viewModel.search)

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

