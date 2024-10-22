//
//  AuthenticationViewModel.swift
//  fitlife
//
//  Created by Jonas Tuttle on 10/4/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import Combine
import CryptoKit

class AuthenticationViewModel: NSObject, ObservableObject {
    // Published properties to bind with the view
    @Published var errorMessage: String? = nil
    @Published var userSession: ASAuthorizationAppleIDCredential? = nil // Holds the Apple ID credential
    
    // Observing the Authorization status
    var currentNonce: String? // Nonce for authentication
    
    override init() {
        super.init()
    }
    
    // MARK: - Sign In with Apple
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    // MARK: - Sign Out
    func signOut() {
        // There is no explicit sign-out function for Apple Sign-In, but you can clear any locally saved session
        self.userSession = nil
        print("User signed out.")
    }
    
    // MARK: - Helpers for Nonce and SHA256
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce.")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()

        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate and ASAuthorizationControllerPresentationContextProviding

extension AuthenticationViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Successfully authenticated
            self.userSession = appleIDCredential
            print("Successfully signed in with Apple ID: \(userIdentifier)")
            
            // Optionally, store userIdentifier, fullName, email locally or in iCloud Keychain
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle the error
        self.errorMessage = "Failed to sign in: \(error.localizedDescription)"
        print("Error occurred during Apple Sign-In: \(error.localizedDescription)")
    }
}

extension AuthenticationViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Return the main window for presentation context
        return UIApplication.shared.windows.first!
    }
}
