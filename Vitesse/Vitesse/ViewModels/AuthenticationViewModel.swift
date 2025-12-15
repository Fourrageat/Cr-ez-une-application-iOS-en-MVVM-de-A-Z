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
    
    private let authenticationRepository: AuthenticationRepository

    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    @MainActor
    func login() async {

        do {
            let response = try await authenticationRepository.login(email: email, password: password)
            print(response)
            isLogged = true
            
        } catch {
            isLogged = false
        }
    }
}
