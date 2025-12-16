//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 16/12/2025.
//


import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    @Published var isLogged: Bool = false
    @Published var errorMessage: String = ""
    
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isEmailValid &&
        !password.isEmpty &&
        !passwordConfirmation.isEmpty
    }
    
    var isEmailValid: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        return predicate.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var isPasswordValid: Bool {
        password == passwordConfirmation
    }
    
    @MainActor
    func register() async throws {

        do {
            _ = try await repository.register(email: email, password: password, firstName: firstName, lastName: lastName)
            
            isLogged = true
        } catch {
            if error.localizedDescription.contains("401") {
                errorMessage = "Bad Credentials"
            } else {
                errorMessage = "Server Error"
            }
            isLogged = false
        }
    }
}
