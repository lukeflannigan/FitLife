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
            
            UserDefaults.standard.set(userIdentifier, forKey: "userSession")
            DispatchQueue.main.async {
                self.isSignedIn = true
            }
        }
    }
    
    func skipSignIn() {
        UserDefaults.standard.set(true, forKey: "skippedSignIn")
        DispatchQueue.main.async {
            self.isSignedIn = true
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
