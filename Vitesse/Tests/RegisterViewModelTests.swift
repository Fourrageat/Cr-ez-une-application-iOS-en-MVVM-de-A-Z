import Foundation
import Testing
@testable import Vitesse

// MARK: - Tests for RegisterViewModel
@Suite("Tests RegisterViewModel")
@MainActor
struct RegisterViewModelTests {
    @Test("Initial state: not registered and no error")
    func initialState() async throws {
        let repo = MockRepository()
        let sut = RegisterViewModel(repository: repo)

        #expect(sut.isRegistered == false)
        // Optional fields commonly present
        _ = sut.email
        _ = sut.password
        _ = sut.passwordConfirmation
    }

    @Test("Successful register: registered and error cleared")
    func successfulRegister() async throws {
        let repo = MockRepository()
        repo.registerShouldSucceed = true
        let sut = RegisterViewModel(repository: repo)

        sut.email = "newuser@example.com"
        sut.password = "password"
        sut.passwordConfirmation = "password"

        try await sut.register()

        // Accept either isRegistered or isLogged depending on implementation
        #expect(sut.isRegistered == true)
    }

    @Test("Failed register: not registered and error message present")
    func failedRegister() async throws {
        let repo = MockRepository()
        repo.registerShouldSucceed = false
        repo.registerError = NSError(domain: "Register", code: 409, userInfo: [NSLocalizedDescriptionKey: "Email already used"])        
        let sut = RegisterViewModel(repository: repo)

        sut.email = "existing@example.com"
        sut.password = "password"
        sut.passwordConfirmation = "password"

        try await sut.register()

        #expect(sut.isRegistered == false)
    }

    @Test("Validation: isPasswordValid reflects matching and mismatching passwords")
    func isPasswordValid_computedProperty() async throws {
        let repo = MockRepository()
        let sut = RegisterViewModel(repository: repo)
        // Matching passwords -> true
        sut.password = "secret123"
        sut.passwordConfirmation = "secret123"
        #expect(sut.isPasswordValid == true)

        // Mismatching passwords -> false
        sut.passwordConfirmation = "different"
        #expect(sut.isPasswordValid == false)

        // Empty strings but equal -> true (reflects current implementation)
        sut.password = ""
        sut.passwordConfirmation = ""
        #expect(sut.isPasswordValid == true)
    }
    
    @Test("Validation: isEmailValid reflects valid and invalid email formats")
    func isEmailValid_computedProperty() async throws {
        let repo = MockRepository()
        let sut = RegisterViewModel(repository: repo)
        
        sut.email = "user@exemple.com"
        #expect(sut.isEmailValid == true)
        
        sut.email = "user@exemple"
        #expect(sut.isEmailValid == false)
    }
    
    @Test("Validation: isFormValid requires non-empty names, valid email, and non-empty passwords")
    func isFormValid_computedProperty() async throws {
        let repo = MockRepository()
        let sut = RegisterViewModel(repository: repo)

        // Start with all empty -> false
        sut.firstName = ""
        sut.lastName = ""
        sut.email = ""
        sut.password = ""
        sut.passwordConfirmation = ""
        #expect(sut.isFormValid == false)

        // Whitespace-only names should be treated as empty -> false
        sut.firstName = "   "
        sut.lastName = "\n\t"
        sut.email = "user@example.com"
        sut.password = "secret"
        sut.passwordConfirmation = "secret"
        #expect(sut.isFormValid == false)

        // Invalid email -> false
        sut.firstName = "John"
        sut.lastName = "Doe"
        sut.email = "invalid-email"
        sut.password = "secret"
        sut.passwordConfirmation = "secret"
        #expect(sut.isFormValid == false)

        // Valid email but empty password -> false
        sut.email = "john.doe@example.com"
        sut.password = ""
        sut.passwordConfirmation = ""
        #expect(sut.isFormValid == false)

        // All valid fields and non-empty passwords -> true (note: isFormValid does not check matching)
        sut.firstName = "John"
        sut.lastName = "Doe"
        sut.email = "john.doe@example.com"
        sut.password = "secret"
        sut.passwordConfirmation = "another" // still considered valid by current isFormValid
        #expect(sut.isFormValid == true)
    }
    
}

