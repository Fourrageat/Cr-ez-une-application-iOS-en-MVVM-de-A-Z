//
//  ContentView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 02/12/2025.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var focusedField: Field?
    @State private var isAppeared: Bool = false
    @State private var isSigningIn: Bool = false
    @State private var showError: Bool = false
    @State private var isKeyboardVisible: Bool = false
    @State private var goToRegister: Bool = false

    private enum Field { case email, password }

    var body: some View {
        NavigationStack {
            ZStack {
                // App-wide background
                AppBackground()
                
                VStack() {
                    // Card container
                    VStack(spacing: 16) {
                        // Email field
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 10) {
                                ZStack(alignment: .leading) {
                                    Text("Email")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .offset(y: (email.isEmpty && focusedField != .email) ? 0 : -18)
                                        .scaleEffect((email.isEmpty && focusedField != .email) ? 1 : 0.9, anchor: .leading)
                                        .opacity(0.9)
                                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: focusedField)
                                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: email)
                                    TextField("", text: $email)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .focused($focusedField, equals: .email)
                                        .submitLabel(.next)
                                }
                            }
                            .padding(14)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(borderColorForEmail, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 10) {
                                ZStack(alignment: .leading) {
                                    Text("Password")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .offset(y: (password.isEmpty && focusedField != .password) ? 0 : -18)
                                        .scaleEffect((password.isEmpty && focusedField != .password) ? 1 : 0.9, anchor: .leading)
                                        .opacity(0.9)
                                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: focusedField)
                                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: password)
                                    SecureField("", text: $password)
                                        .textContentType(.password)
                                        .focused($focusedField, equals: .password)
                                        .submitLabel(.go)
                                }
                            }
                            .padding(14)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(borderColorForPassword, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                        }
                        
                        // Sign In button
                        Button {
                            signIn()
                        } label: {
                            HStack {
                                if isSigningIn {
                                    ProgressView()
                                        .tint(.white)
                                }
                                Text(isSigningIn ? "Signing In…" : "Sign In")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.accentColor : Color.accentColor.opacity(0.5))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: Color.accentColor.opacity(isFormValid ? 0.25 : 0.0), radius: 14, x: 0, y: 8)
                            .scaleEffect(isSigningIn ? 0.98 : 1)
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isSigningIn)
                        }
                        .disabled(!isFormValid || isSigningIn)
                        .accessibilityLabel("Login")
                        
                        // Register button
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                goToRegister = true
                            }
                        } label: {
                            Text("Register")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(Color.accentColor, lineWidth: 1)
                                )
                        }
                        .accessibilityLabel("Register")
                        
                        if showError {
                            Text("Bad credentials. Try again.")
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .cardContainer(isAppeared: isAppeared, shakeOffset: shakeOffset)
                }
                .padding(.horizontal)
            }
            .contentShape(Rectangle())
            .overlay(alignment: .top) {
                VStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.accentColor)
                    Text("Welcome on Vitesse")
                        .font(.title2).bold()
                        .foregroundStyle(.primary)
                }
                .opacity(isKeyboardVisible ? 0 : 1)
                .offset(y: isKeyboardVisible ? -20 : 0)
                .animation(.easeInOut(duration: 0.25), value: isKeyboardVisible)
                .padding(.top, 40)
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $goToRegister) {
                RegisterView()
            }
            .onAppear {
                isAppeared = true
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                    withAnimation(.easeInOut(duration: 0.25)) { isKeyboardVisible = true }
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    withAnimation(.easeInOut(duration: 0.25)) { isKeyboardVisible = false }
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            }
        }
    }

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }

    private var borderColorForEmail: Color {
        if showError { return .red }
        return focusedField == .email ? .accentColor : Color.secondary.opacity(0.3)
    }

    private var borderColorForPassword: Color {
        if showError { return .red }
        return focusedField == .password ? .accentColor : Color.secondary.opacity(0.3)
    }

    private func signIn() {
        guard isFormValid else {
            withAnimation(.default) { showError = true }
            shake()
            return
        }
        showError = false
        isSigningIn = true
        // Simulate async sign-in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isSigningIn = false
                // Flip to success or show error example
                let success = Bool.random()
                if !success {
                    showError = true
                    shake()
                }
            }
        }
    }

    @State private var shakeOffset: CGFloat = 0
    private func shake() {
        let base: [CGFloat] = [0, -10, 10, -8, 8, -5, 5, 0]
        var delay: Double = 0
        for value in base {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                    shakeOffset = value
                }
            }
            delay += 0.04
        }
    }
}

#Preview {
    SignInView()
}
