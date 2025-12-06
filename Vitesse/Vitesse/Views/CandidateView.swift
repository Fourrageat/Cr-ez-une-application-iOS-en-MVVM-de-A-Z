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
                        if candidate.phone == nil {
                            Text("Not available")
                                .foregroundStyle(.secondary)
                        } else {
                            Text(candidate.phone!)
                        }
                    }
                    
                    HStack {
                        Text("Email :")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Text(candidate.email)
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
                            OpenLinkButton(url: url, title: "Go on Linkedin")
                        } else {
                            Text("Not available")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Note :")
                            .font(.system(size: 20, weight: .bold))
                        Text(candidate.note ?? "Not available")
                            .font(.system(size: 14))
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 10)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(30)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isEditing {
                        print("Sending...")
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

    var body: some View {
        Button {
            openURL(url)
        } label: {
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

