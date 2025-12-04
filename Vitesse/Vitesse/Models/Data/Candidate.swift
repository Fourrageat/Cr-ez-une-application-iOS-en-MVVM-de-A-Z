//
//  Candidate.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 04/12/2025.
//

import Foundation

struct Candidate: Identifiable, Hashable {
    let id = UUID()
    var firstName: String
    var lastName: String
    var isFavorite: Bool = false

    var displayName: String { "\(firstName) \(lastName)" }
}
