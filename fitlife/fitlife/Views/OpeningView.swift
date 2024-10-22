// OpeningView.swift
//
// Created by Luke Flannigan on 9/26/24.
//
import SwiftUI
import AuthenticationServices

struct OpeningView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
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
                
                // Sign In with Apple Button
                SignInWithAppleButton(
                    onRequest: { request in
                        viewModel.signInWithApple()
                    },
                    onCompletion: { result in
                        handleSignInResult(result)
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 56)
                .cornerRadius(12)
                .padding(.horizontal, 30)
                
                // Continue without sign-in Button
                Button(action: {
                    viewModel.skipSignIn()
                }) {
                    Text("Continue without sign in")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
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

