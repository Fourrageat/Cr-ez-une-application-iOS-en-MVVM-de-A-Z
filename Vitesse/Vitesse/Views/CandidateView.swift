//
//  CondidateView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct CandidateView: View {
    var candidate: Candidate
    
    @State var isEditing: Bool = false
    @State private var editedPhone: String = ""
    @State private var editedEmail: String = ""
    @State private var editedLinkedin: String = ""
    @State private var editedNote: String = ""
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(alignment: .leading, spacing: 40) {
                HStack {
                    Text("\(candidate.firstName) \(candidate.lastName.first.map { String($0) } ?? "").")
                        .font(.system(size: 35, weight: .bold))
                    Spacer()
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(candidate.isFavorite ? .yellow: .primary)
                        .font(.system(size: 35))
                }

                if isEditing {
                    CandidateEditView(editedPhone: $editedPhone,
                                      editedEmail: $editedEmail,
                                      editedLinkedin: $editedLinkedin,
                                      editedNote: $editedNote)
                } else {
                    CandidateReadOnlyView(candidate: candidate,
                                          phone: editedPhone,
                                          email: editedEmail,
                                          linkedin: editedLinkedin,
                                          note: editedNote)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(30)
            .onAppear {
                editedPhone = candidate.phone ?? ""
                editedEmail = candidate.email
                editedLinkedin = candidate.linkedin ?? ""
                editedNote = candidate.note ?? ""
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isEditing {
                        // Leaving edit mode: normalize current edits (even if empty) so they become the new displayed values
                        editedPhone = editedPhone.trimmingCharacters(in: .whitespacesAndNewlines)
                        editedEmail = editedEmail.trimmingCharacters(in: .whitespacesAndNewlines)
                        editedLinkedin = editedLinkedin.trimmingCharacters(in: .whitespacesAndNewlines)
                        editedNote = editedNote.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    isEditing.toggle()
                } label: {
                    if isEditing {
                        Text("Done")
                    } else {
                        Text("Edit")
                    }
                }
            }
        }
    }
}

struct CandidateReadOnlyView: View {
    let candidate: Candidate
    let phone: String
    let email: String
    let linkedin: String
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
                let urlString = linkedin.trimmingCharacters(in: .whitespacesAndNewlines)
                if let url = URL(string: urlString), !urlString.isEmpty {
                    OpenLinkButton(url: url, title: "Go on Linkedin", candidate: candidate, isEditing: false, editedLinkedin: .constant(linkedin))
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
                    Text(note).font(.system(size: 14))
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
    @Binding var editedLinkedin: String
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
                TextField("Enter linkedin link", text: $editedLinkedin)
                    .multilineTextAlignment(.trailing)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Note :")
                    .font(.system(size: 20, weight: .bold))
                TextField("Enter a note", text: $editedNote)
                    .multilineTextAlignment(.leading)
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
    @Binding var editedLinkedin: String

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
                TextField("Enter linkedin link", text: $editedLinkedin)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CandidateView(candidate: Candidate(
            firstName: "John",
            lastName: "Smith",
            isFavorite: false,
            phone: "+1 (555) 123-4567",
            email: "john.smith@example.com",
            note: "Met at iOS meetup. Strong SwiftUI skills.",
            linkedin: "https://www.linkedin.com/in/johnsmith"
        ))
    }
}

