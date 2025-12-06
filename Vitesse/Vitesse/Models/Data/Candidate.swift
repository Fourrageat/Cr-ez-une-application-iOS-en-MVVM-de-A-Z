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

struct Samples {
    static let candidates: [Candidate] = [
        .init(firstName: "Alice", lastName: "Martin", isFavorite: true, phone: "+33 6 12 34 56 01", email: "alice.martin@example.com", note: "iOS Developer", linkedin: "https://linkedin.com/in/alicemartin"),
        .init(firstName: "Bob", lastName: "Durand", isFavorite: false, phone: nil, email: "bob.durand@example.com", note: "Backend Go", linkedin: nil),
        .init(firstName: "Chloé", lastName: "Bernard", isFavorite: true, phone: "+33 6 12 34 56 03", email: "chloe.bernard@example.com", note: "Product Designer", linkedin: "https://linkedin.com/in/chloebernard"),
        .init(firstName: "David", lastName: "Moreau", isFavorite: false, phone: "+33 6 12 34 56 04", email: "david.moreau@example.com", note: "Full‑Stack", linkedin: nil),
        .init(firstName: "Éva", lastName: "Lefèvre", isFavorite: false, phone: nil, email: "eva.lefevre@example.com", note: "QA Engineer", linkedin: nil),
        .init(firstName: "Farid", lastName: "Rossi", isFavorite: false, phone: "+33 6 12 34 56 06", email: "farid.rossi@example.com", note: nil, linkedin: "https://linkedin.com/in/faridrossi"),
        .init(firstName: "Gaëlle", lastName: "Petit", isFavorite: false, phone: "+33 6 12 34 56 07", email: "gaelle.petit@example.com", note: "Data Analyst", linkedin: nil),
        .init(firstName: "Hugo", lastName: "Robert", isFavorite: false, phone: nil, email: "hugo.robert@example.com", note: "SRE", linkedin: nil),
        .init(firstName: "Inès", lastName: "Richard", isFavorite: true, phone: "+33 6 12 34 56 09", email: "ines.richard@example.com", note: "UX Researcher", linkedin: "https://linkedin.com/in/inesrichard"),
        .init(firstName: "Jules", lastName: "Dubois", isFavorite: false, phone: "+33 6 12 34 56 10", email: "jules.dubois@example.com", note: nil, linkedin: nil),
        .init(firstName: "Karim", lastName: "Lambert", isFavorite: false, phone: nil, email: "karim.lambert@example.com", note: "Android", linkedin: nil),
        .init(firstName: "Laura", lastName: "Girard", isFavorite: true, phone: "+33 6 12 34 56 12", email: "laura.girard@example.com", note: "Project Manager", linkedin: "https://linkedin.com/in/lauragirard"),
        .init(firstName: "Marc", lastName: "Faure", isFavorite: false, phone: "+33 6 12 34 56 13", email: "marc.faure@example.com", note: nil, linkedin: nil),
        .init(firstName: "Nina", lastName: "Carpentier", isFavorite: false, phone: nil, email: "nina.carpentier@example.com", note: "Data Scientist", linkedin: nil),
        .init(firstName: "Olivier", lastName: "Renard", isFavorite: false, phone: "+33 6 12 34 56 15", email: "olivier.renard@example.com", note: nil, linkedin: "https://linkedin.com/in/olivierrenard"),
        .init(firstName: "Paul", lastName: "Lemaire", isFavorite: false, phone: nil, email: "paul.lemaire@example.com", note: "DevOps", linkedin: nil),
        .init(firstName: "Quitterie", lastName: "Lopez", isFavorite: true, phone: "+33 6 12 34 56 17", email: "quitterie.lopez@example.com", note: "iOS + SwiftUI", linkedin: "https://linkedin.com/in/quitterielo"),
        .init(firstName: "Romain", lastName: "Morel", isFavorite: false, phone: "+33 6 12 34 56 18", email: "romain.morel@example.com", note: nil, linkedin: nil),
        .init(firstName: "Sarah", lastName: "Picard", isFavorite: false, phone: nil, email: "sarah.picard@example.com", note: "Product Owner", linkedin: nil),
        .init(firstName: "Thomas", lastName: "Gauthier", isFavorite: false, phone: "+33 6 12 34 56 20", email: "thomas.gauthier@example.com", note: nil, linkedin: "https://linkedin.com/in/thomasgauthier")
    ]
}
