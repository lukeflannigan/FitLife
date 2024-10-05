//
//  AuthenticationViewModel.swift
//  fitlife
//
//  Created by Jonas Tuttle on 10/4/24.
//

import Foundation
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    // Published properties to bind with the view
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String? = nil
    @Published var userSession: User? = nil  // Firebase User session
    
    // Firebase Auth instance
    private let auth = Auth.auth()
    
    // MARK: - Sign In
    func signIn() {
        // Clear previous error message
        errorMessage = nil
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                // Set error message for view to display
                self.errorMessage = "Failed to sign in: \(error.localizedDescription)"
                return
            }
            
            // User signed in successfully
            self.userSession = result?.user
            print("Successfully signed in with user: \(self.userSession?.uid ?? "")")
        }
    }
    
    // MARK: - Sign Up
    func signUp() {
        // Clear previous error message
        errorMessage = nil
        
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            self.errorMessage = "Email, password, and confirm password fields cannot be empty."
            return
        }
        
        guard password == confirmPassword else {
            self.errorMessage = "Passwords do not match."
            return
        }
        
        // Sign up user
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                // Set error message for view to display
                self.errorMessage = "Failed to sign up: \(error.localizedDescription)"
                return
            }
            
            // User signed up successfully
            self.userSession = result?.user
            print("Successfully signed up with user: \(self.userSession?.uid ?? "")")
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try auth.signOut()
            self.userSession = nil
            print("User signed out.")
        } catch {
            self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Forgot Password
    func sendPasswordReset() {
        guard !email.isEmpty else {
            self.errorMessage = "Please enter your email."
            return
        }
        
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = "Error sending reset link: \(error.localizedDescription)"
            } else {
                print("Password reset email sent.")
            }
        }
    }
}
