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
        Text(candidate.firstName)
        Text(candidate.lastName)
        Text(candidate.phone!)
        Text(candidate.email)
        Text(candidate.note!)
        Text(candidate.linkedin!)
        Image(systemName: candidate.isFavorite ? "star.fill" : "star")
            .foregroundStyle(Color.yellow)
        
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
