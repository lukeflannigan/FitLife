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
    @Published var isSignedIn = false  // Track sign-in status
    
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
            self.userSession = userIdentifier  // Save user session
            
            // Store session in UserDefaults for future use
            UserDefaults.standard.set(userIdentifier, forKey: "userSession")
            
            // Set isSignedIn to true to trigger navigation
            DispatchQueue.main.async {
                self.isSignedIn = true
            }
        }
    }
    
    func skipSignIn() {
        // Mark user as having skipped sign-in
        UserDefaults.standard.set(true, forKey: "skippedSignIn")
        
        // Directly set isSignedIn to true to trigger navigation to MainView
        DispatchQueue.main.async {
            self.isSignedIn = true
        }
    }
    
    // Apple Sign In Delegate methods
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
