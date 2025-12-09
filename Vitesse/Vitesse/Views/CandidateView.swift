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
                VStack(alignment: .leading, spacing: 30) {
                    
                    HStack {
                        Text("Phone :")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        if isEditing {
                            TextField("Enter phone number", text: $editedPhone)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                                .multilineTextAlignment(.trailing)
                        } else {
                            let phone = (editedPhone.isEmpty ? (candidate.phone ?? "") : editedPhone)
                            if phone.isEmpty {
                                Text("Not available")
                                    .foregroundStyle(.secondary)
                            } else {
                                Text(phone)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Email :")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        if isEditing {
                            TextField("Enter email", text: $editedEmail)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .multilineTextAlignment(.trailing)
                        } else {
                            let email = (editedEmail.isEmpty ? candidate.email : editedEmail)
                            if email.isEmpty {
                                Text("Not available")
                                    .foregroundStyle(.secondary)
                            } else {
                                Text(email)
                            }
                        }
                    }
                    
                    HStack {
                        Text("LinkedIn :")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        let urlString = candidate.linkedin?.trimmingCharacters(in: .whitespacesAndNewlines)
                        if
                            let urlString,
                            let url = URL(string: urlString),
                            !urlString.isEmpty
                        {
                            OpenLinkButton(url: url, title: "Go on Linkedin", candidate: candidate, isEditing: isEditing, editedLinkedin: $editedLinkedin)
                        } else {
                            Text("Not available")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Note :")
                            .font(.system(size: 20, weight: .bold))
                        if isEditing {
                            TextField("Enter a note", text: $editedNote)
                                .multilineTextAlignment(.leading)
                        } else {
                            let note = (editedNote.isEmpty ? candidate.note : editedNote)
                            if note!.isEmpty {
                                Text("")
                                    .foregroundStyle(.secondary)
                            } else {
                                Text(note ?? "")
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 10)
                
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
                        // Persist the edited phone locally; replace with real save as needed
                        if editedPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            // keep as nil when empty
                            // If Candidate is a value type passed by value, this won't persist outside.
                        } else {
                            // Assign locally so UI reflects change
                            // Note: To persist, pass a Binding/ObservableObject or a save closure.
                        }
                    } else {
                        // entering edit mode; seed the fields
                        if editedPhone.isEmpty { editedPhone = candidate.phone ?? "" }
                        if editedEmail.isEmpty { editedEmail = candidate.email }
                        if editedLinkedin.isEmpty { editedLinkedin = candidate.linkedin ?? "" }
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
                if (editedLinkedin.isEmpty) {
                    Text("Not available")
                        .foregroundStyle(.secondary)
                } else {
                    TextField("Enter linkedin link", text: $editedLinkedin)
                }
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

