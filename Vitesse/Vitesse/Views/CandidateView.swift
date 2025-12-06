//
//  CondidateView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct CandidateView: View {
    var candidate: Candidate
    
    var body: some View {
        ZStack {
        AppBackground()
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    Text("\(candidate.firstName) \(candidate.lastName.first.map { String($0) } ?? "").")
                        .font(.system(size: 35, weight: .bold))
                    Spacer()
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(candidate.isFavorite ? .yellow: .secondary)
                        .font(.system(size: 35))
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(30)
        }
    }
}

#Preview {
    CandidateView(candidate: Candidate(
        firstName: "John",
        lastName: "Smith",
        isFavorite: true,
        phone: "+1 (555) 123-4567",
        email: "john.smith@example.com",
        note: "Met at iOS meetup. Strong SwiftUI skills.",
        linkedin: "https://www.linkedin.com/in/johnsmith"
    ))
}

