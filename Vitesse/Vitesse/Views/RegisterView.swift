//
//  RegisterView.swift
//  Vitesse
//
//  Created by Baptiste Fourrageat on 03/12/2025.
//

import SwiftUI

struct RegisterView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    
    @FocusState private var focusedField: Field?
    @State private var isAppeared: Bool = false
    @State private var isCreating: Bool = false
    @State private var showError: Bool = false
    @State private var isKeyboardVisible: Bool = false

    private enum Field { case email, password, passwordConfirmation, firstName, lastName }

    var body: some View {
        ZStack {
            // App-wide background
            AppBackground()

            VStack() {
                // Card container
                VStack(spacing: 16) {
                    
                    // First name field
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 10) {
                            ZStack(alignment: .leading) {
                                Text("First name")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .offset(y: (firstName.isEmpty && focusedField != .firstName) ? 0 : -18)
                                    .scaleEffect((firstName.isEmpty && focusedField != .firstName) ? 1 : 0.9, anchor: .leading)
                                    .opacity(0.9)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: focusedField)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: firstName)
                                TextField("", text: $firstName)
                                    .textContentType(.name)
                                    .keyboardType(.default)
                                    .focused($focusedField, equals: .firstName)
                                    .submitLabel(.next)
                            }
                        }
                        .padding(14)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                    }
                    
                    // Last name field
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 10) {
                            ZStack(alignment: .leading) {
                                Text("Last name")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .offset(y: (lastName.isEmpty && focusedField != .lastName) ? 0 : -18)
                                    .scaleEffect((lastName.isEmpty && focusedField != .lastName) ? 1 : 0.9, anchor: .leading)
                                    .opacity(0.9)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: focusedField)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: lastName)
                                TextField("", text: $lastName)
                                    .textContentType(.name)
                                    .keyboardType(.default)
                                    .focused($focusedField, equals: .lastName)
                                    .submitLabel(.next)
                            }
                        }
                        .padding(14)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                    }
                    
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
                    
                    // Password confirmation field
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 10) {
                            ZStack(alignment: .leading) {
                                Text("Confirm password")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .offset(y: (passwordConfirmation.isEmpty && focusedField != .passwordConfirmation) ? 0 : -18)
                                    .scaleEffect((passwordConfirmation.isEmpty && focusedField != .passwordConfirmation) ? 1 : 0.9, anchor: .leading)
                                    .opacity(0.9)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: focusedField)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: passwordConfirmation)
                                SecureField("", text: $passwordConfirmation)
                                    .textContentType(.password)
                                    .focused($focusedField, equals: .passwordConfirmation)
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

                    // Create button
                    Button {
                        create()
                    } label: {
                        HStack {
                            if isCreating {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text(isCreating ? "Creating…" : "Create")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.accentColor : Color.accentColor.opacity(0.5))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Color.accentColor.opacity(isFormValid ? 0.25 : 0.0), radius: 14, x: 0, y: 8)
                        .scaleEffect(isCreating ? 0.98 : 1)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isCreating)
                    }
                    .disabled(!isFormValid || isCreating)
                    .accessibilityLabel("Create")

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
                Text("Register")
                    .font(.title2).bold()
                    .foregroundStyle(.primary)
            }
            .opacity(isKeyboardVisible ? 0 : 1)
            .offset(y: isKeyboardVisible ? -20 : 0)
            .animation(.easeInOut(duration: 0.25), value: isKeyboardVisible)
            .padding(.top, 40)
            .padding(.horizontal)
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

    private var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        !passwordConfirmation.isEmpty
    }
    
    private var isPasswordValid: Bool {
        password == passwordConfirmation
    }
    
    private var borderColorForFirstName: Color {
        if showError { return .red }
        return focusedField == .firstName ? .accentColor : Color.secondary.opacity(0.3)
    }
    
    private var borderColorForLastName: Color {
        if showError { return .red }
        return focusedField == .lastName ? .accentColor : Color.secondary.opacity(0.3)
    }
    
    private var borderColorForEmail: Color {
        if showError { return .red }
        return focusedField == .email ? .accentColor : Color.secondary.opacity(0.3)
    }

    private var borderColorForPassword: Color {
        if showError { return .red }
        return focusedField == .password ? .accentColor : Color.secondary.opacity(0.3)
    }
    
    private var borderColorForPasswordConfirmation: Color {
        if showError { return .red }
        return focusedField == .passwordConfirmation ? .accentColor : Color.secondary.opacity(0.3)
    }

    private func create() {
        guard isFormValid else {
            withAnimation(.default) { showError = true }
            shake()
            return
        }
        showError = false
        isCreating = true
        // Simulate async sign-in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isCreating = false
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
    RegisterView()
}
