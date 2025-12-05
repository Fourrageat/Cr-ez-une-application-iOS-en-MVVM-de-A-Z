//
//  Candidate.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import Foundation

struct Candidate: Identifiable, Hashable, Codable {
    var id = UUID()
    let firstName: String
    let lastName: String
    var isFavorite: Bool = false
    let phone: String?
    let email: String
    let note: String?
    let linkedin: String?
}

struct Candidates: Codable {
    let candidates: [Candidate]
}
