// OpeningView.swift
//
// Created by Luke Flannigan on 9/26/24.
//

import SwiftUI
import AuthenticationServices

struct OpeningView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isNavigatingToMainView = false  // State for navigation
    
    var body: some View {
        NavigationView {  // Embed in a NavigationView
            ZStack {
                GradientBackground()  // Custom background
                
                VStack(spacing: 30) {
                    Text("FitLife")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 100)
                    
                    Text("TRAINING DONE SMARTER")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Spacer()
                    
                    SignInWithAppleButton(
                        onRequest: { request in
                            viewModel.signInWithApple()
                        },
                        onCompletion: { result in
                            handleSignInResult(result)
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 70)
                    .cornerRadius(16)
                    .padding(.horizontal, 40)
                    
                    // Continue without sign-in Button (more subtle)
                    Button(action: {
                        viewModel.skipSignIn()
                        isNavigatingToMainView = true  // Trigger navigation
                    }) {
                        Text("Continue without sign in")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 160)
                    
                    NavigationLink(destination: MainView(), isActive: $isNavigatingToMainView) {
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func handleSignInResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            viewModel.processAppleSignIn(auth)
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct OpeningView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningView()
    }
}
