//
//  AuthenticationViewModel.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 15/12/2025.
//
import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var showError: Bool = false
    @Published var isSigningIn: Bool = false
    @Published var goToCandidates: Bool = false
    
    private let authenticationRepository: AuthenticationRepository

    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    @MainActor
    func login() async {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError = true
            return
        }

        showError = false
        isSigningIn = true

        do {
            let response = try await authenticationRepository.login(email: email, password: password)
            isSigningIn = false
            print(response)
        } catch {
            isSigningIn = false
            showError = true
        }
    }
    
}
