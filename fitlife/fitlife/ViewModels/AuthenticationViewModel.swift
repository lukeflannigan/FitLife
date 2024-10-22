//
//  AuthenticationViewModel.swift
//  fitlife
//
//  Created by Jonas Tuttle on 10/4/24.
//

import SwiftUI
import AuthenticationServices

class AuthenticationViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var userSession: String? = nil  // This tracks user session
    @Published var errorMessage: String? = nil
    
    override init() {
        super.init()
    }
    
    // Function to initiate Apple Sign-In process
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // ASAuthorizationControllerDelegate methods
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            self.userSession = userIdentifier  // Save user session
            
            if let email = appleIDCredential.email {
                self.email = email
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.errorMessage = error.localizedDescription
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
    
    // Existing email/password methods (you can adjust as needed)
    func signIn() {
        // Implement email/password sign-in logic here
        if email == "test@test.com" && password == "password" {  // Example
            self.userSession = "exampleSession"
        } else {
            self.errorMessage = "Invalid email or password"
        }
    }
    
    func signUp() {
        // Implement sign-up logic
        if password == confirmPassword {
            self.userSession = "newUserSession"
        } else {
            self.errorMessage = "Passwords do not match"
        }
    }
    
    func sendPasswordReset() {
        // Implement password reset functionality
        self.errorMessage = "Password reset functionality not implemented yet"
    }
}
