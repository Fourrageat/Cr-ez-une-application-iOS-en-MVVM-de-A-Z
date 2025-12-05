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
    }
}

#Preview {
    CandidateView(candidate: Candidate(firstName: "John", lastName: "Smith"))
}

