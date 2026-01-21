import Foundation
import Testing
@testable import Vitesse

// MARK: - Tests for AuthenticationViewModel
@Suite("Tests AuthenticationViewModel")
@MainActor
struct AuthenticationViewModelTests {

    @Test("Initial state: not logged and no error")
    func initialState() async throws {
        let mockRepository = MockRepository()
        let sut = AuthenticationViewModel(repository: mockRepository)

        #expect(sut.isLogged == false)
        #expect(sut.errorMessage.isEmpty)
    }

    @Test("Successful login: logged and error cleared")
    func successfulLogin() async throws {
        let mockRepository = MockRepository()
        mockRepository.loginShouldSucceed = true
        mockRepository.loginReturnedToken = "abc123"
        let sut = AuthenticationViewModel(repository: mockRepository)

        // Provide credentials via the view model API used in production
        sut.email = "user@example.com"
        sut.password = "password"

        await sut.login()

        #expect(sut.isLogged == true)
        #expect(sut.errorMessage.isEmpty)
    }

    @Test("Failed login: not logged and error message present")
    func failedLogin() async throws {
        let repo = MockRepository()
        repo.loginShouldSucceed = false
        repo.loginError = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Bad credentials"])        
        let sut = AuthenticationViewModel(repository: repo)

        sut.email = "user@example.com"
        sut.password = "wrong"

        await sut.login()

        #expect(sut.isLogged == false)
        #expect(!sut.errorMessage.isEmpty)
        let message = sut.errorMessage
        #expect(message.contains("Bad Credentials") || message.contains("Server Error"))
    }
}

