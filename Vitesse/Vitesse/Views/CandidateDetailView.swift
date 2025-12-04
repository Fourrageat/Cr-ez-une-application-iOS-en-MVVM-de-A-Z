//
//  SwiftUIView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct CandidateDetailView: View {
    var candidate: Candidate
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CandidateDetailView(candidate: .init(firstName: "John", lastName: "Snow", isFavorite: false))
}
