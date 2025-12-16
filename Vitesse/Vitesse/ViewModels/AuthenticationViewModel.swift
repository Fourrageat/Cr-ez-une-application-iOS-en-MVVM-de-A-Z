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
    
    @Published var isLogged: Bool = false
    @Published var errorMessage: String = ""
    
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    @MainActor
    func login() async {

        do {
            _ = try await repository.login(email: email, password: password)
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
