//
//  CondidateView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct CandidateView: View {
    private let candidate: Candidate

    @ObservedObject private var viewModel = CandidateViewModel()

    init(candidate: Candidate) {
        self.candidate = candidate
    }
    
    var body: some View {
        ZStack {
            AppBackground()

            Group {
                VStack(alignment: .leading, spacing: 40) {
                    HStack {
                        Text("\(viewModel.candidate.firstName) \(viewModel.candidate.lastName.first.map { String($0) } ?? "").")
                            .font(.system(size: 35, weight: .bold))
                        Spacer()
                        Image(systemName: viewModel.candidate.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(viewModel.candidate.isFavorite ? .yellow: .primary)
                            .font(.system(size: 35))
                    }

                    if viewModel.isEditing {
                        CandidateEditView(editedPhone: Binding(get: { viewModel.candidatePhone }, set: { viewModel.candidatePhone = $0 }),
                                          editedEmail: Binding(get: { viewModel.candidateEmail }, set: { viewModel.candidateEmail = $0 }),
                                          editedLinkedinURL: Binding(get: { viewModel.candidateLinkedinURL }, set: { viewModel.candidateLinkedinURL = $0 }),
                                          editedNote: Binding(get: { viewModel.candidateNote }, set: { viewModel.candidateNote = $0 }))
                    } else {
                        CandidateReadOnlyView(candidate: viewModel.candidate,
                                              phone: viewModel.candidatePhone,
                                              email: viewModel.candidateEmail,
                                              linkedinURL: viewModel.candidateLinkedinURL,
                                              note: viewModel.candidateNote)
                    }
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(30)
        }
        .toolbar {
            if viewModel.isEditing {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Task {
                            do {
                                try await viewModel.cancelEditing()
                            } catch {
                                print("Failed to cancel editing: \(error)")
                            }
                        }
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            do {
                                viewModel.doneEditing()
                            }
                        }
                    } label: {
                        Text("Done")
                    }
                }
            }
            else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            do {
                                viewModel.isEditing.toggle()
                            }
                        }
                    } label: {
                        Text("Edit")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .task {
            await viewModel.fetchCandidate(candidateId: candidate.id)
        }
    }
}

struct CandidateReadOnlyView: View {
    let candidate: Candidate
    let phone: String
    let email: String
    let linkedinURL: String
    let note: String

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("Phone :")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Not available").foregroundStyle(.secondary)
                } else {
                    Text(phone)
                }
            }
            HStack {
                Text("Email :")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Not available").foregroundStyle(.secondary)
                } else {
                    Text(email)
                }
            }
            HStack {
                Text("LinkedIn :")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                let urlString = linkedinURL.trimmingCharacters(in: .whitespacesAndNewlines)
                if let url = URL(string: urlString), !urlString.isEmpty {
                    OpenLinkButton(url: url, title: "Go on Linkedin", candidate: candidate, isEditing: false, editedLinkedinURL: .constant(linkedinURL))
                } else {
                    Text("Not available").foregroundStyle(.secondary)
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Note :")
                    .font(.system(size: 20, weight: .bold))
                if note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Not available").foregroundStyle(.secondary)
                } else {
                    Text(note).font(.system(size: 17))
                }
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 10)
    }
}

struct CandidateEditView: View {
    @Binding var editedPhone: String
    @Binding var editedEmail: String
    @Binding var editedLinkedinURL: String
    @Binding var editedNote: String

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("Phone :")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                TextField("Enter phone number", text: $editedPhone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Email :")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                TextField("Enter email", text: $editedEmail)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("LinkedIn :")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                TextField("Enter linkedin link", text: $editedLinkedinURL)
                    .multilineTextAlignment(.trailing)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Note :")
                    .font(.system(size: 20, weight: .bold))
                ZStack(alignment: .topLeading) {
                    if editedNote.isEmpty {
                        Text("Enter a note")
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    TextEditor(text: $editedNote)
                        .multilineTextAlignment(.leading)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color(.systemBackground))
                                )
                        )
                        .frame(height: 150)
                }
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 10)
    }
}

struct OpenLinkButton: View {
    @Environment(\.openURL) private var openURL
    let url: URL
    var title: String
    let candidate: Candidate
    var isEditing: Bool
    @Binding var editedLinkedinURL: String

    var body: some View {
        Button {
            openURL(url)
        } label: {
            if !isEditing {
                
                HStack(spacing: 8) {
                    Image(systemName: "link")
                    Text(title)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.blue.opacity(0.15))
                )
                .foregroundStyle(.blue)
            } else {
                TextField("Enter linkedin link", text: $editedLinkedinURL)
            }
        }
    }
}

#Preview {

}

