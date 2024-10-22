// SignInView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var navigateToMain = false  // Navigation flag
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerSection
                    signInWithAppleButton
                    signUpSection
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
            }
            
            .fullScreenCover(isPresented: $navigateToMain) {
                MainView()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Welcome Back")
                .font(.system(size: 32, weight: .bold))
            Text("Sign in with Apple to continue")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .foregroundColor(.white)
    }
    
    
    private var signInWithAppleButton: some View {
        VStack { // Wrap the button in a container like VStack to ensure consistent return
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    // Optional: Customize request if needed
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                            // Handle successful authorization
                            viewModel.userSession = appleIDCredential
                            navigateToMain = true
                        }
                    case .failure(let error):
                        // Handle error
                        viewModel.errorMessage = error.localizedDescription
                    }
                }
            )
            .frame(width: 280, height: 50)
            .signInWithAppleButtonStyle(.black)
            .padding()

            // Conditionally show error message if it exists
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
            }
        }
    }
    
    private var signUpSection: some View {
        HStack {
            Text("Don't have an account?")
            NavigationLink("Sign Up", destination: SignUpView())
        }
        .font(.system(size: 14))
        .foregroundColor(.white)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
