//
//  CandidateCard.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import SwiftUI

struct CandidateCard: View {
    var candidate: Candidate

    var initials: String {
        let f = candidate.firstName.first.map { String($0) } ?? ""
        let l = candidate.lastName.first.map { String($0) } ?? ""
        return (f + l).uppercased()
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.quaternary)
                Text(initials)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 36, height: 36)

            HStack(spacing: 2) {
                Text(candidate.firstName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("\(candidate.lastName.first.map { String($0) } ?? "").")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(.leading, 4)
            }

            Spacer(minLength: 8)

            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                .foregroundStyle(candidate.isFavorite ? .yellow : .secondary)
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            Group {
                if #available(iOS 17.0, *) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.separator.opacity(0.4))
                } else {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.secondary.opacity(0.25))
                }
            }
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .hoverEffect(.highlight)
    }
}

struct CandidateCard_Previews: PreviewProvider {
    static var previews: some View {
        let sample = Samples.candidates[0]

        return Group {
            // Centered preview of the card itself
            ZStack {
                AppBackground()
                CandidateCard(candidate: sample)
            }
            .previewDisplayName("CandidateCard – Centered")
        }
    }
}

