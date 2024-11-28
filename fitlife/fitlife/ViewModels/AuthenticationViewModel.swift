//
//  AuthenticationViewModel.swift
//  fitlife
//
//  Created by Jonas Tuttle on 10/4/24.
//

import SwiftUI
import AuthenticationServices

class AuthenticationViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @Published var userSession: String? = nil
    @Published var errorMessage: String? = nil
    @Published var isSignedIn = false
    @Published var isNewUser = false  // Track if the user is new
    @Published var skippedSignIn = false  // Track if the user skipped sign-in
    
    override init() {
        super.init()
    }
    
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func processAppleSignIn(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            self.userSession = userIdentifier
            
            // Check if the user is new
            if isNewUser(userIdentifier) {
                self.isNewUser = true
            } else {
                self.isNewUser = false
            }
            
            UserDefaults.standard.set(userIdentifier, forKey: "userSession")
            DispatchQueue.main.async {
                self.isSignedIn = true
            }
        }
    }
    
    func skipSignIn() {
        UserDefaults.standard.set(true, forKey: "skippedSignIn")
        DispatchQueue.main.async {
            self.skippedSignIn = true
            self.isSignedIn = true
            self.isNewUser = true  // Skipped sign-in always routes to WelcomeView
        }
    }
    
    private func isNewUser(_ userIdentifier: String) -> Bool {
        // Simulated database check. Replace this with a real database query.
        if let existingUsers = UserDefaults.standard.array(forKey: "existingUsers") as? [String] {
            return !existingUsers.contains(userIdentifier)
        } else {
            // First time running the app, no users exist yet
            var users = [String]()
            users.append(userIdentifier)  // Add this user as the first entry
            UserDefaults.standard.set(users, forKey: "existingUsers")
            return true
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        processAppleSignIn(authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.errorMessage = error.localizedDescription
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}
