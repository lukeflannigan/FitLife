// OpeningView.swift
//
// Created by Luke Flannigan on 9/26/24.
//


import SwiftUI
import SwiftData
import AuthenticationServices

struct OpeningView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isNavigatingToMainView = false
    @State private var isNavigatingToWelcomeView = false
    @State private var userGoals = UserGoals()

    var body: some View {
        NavigationView {
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
                    
                    // Sign in with Apple button
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
                    
                    // Continue without sign-in Button
                    Button(action: {
                        viewModel.skipSignIn()
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
                    
                    // NavigationLink to MainView
                    NavigationLink(destination: MainView()
                        .environment(\.modelContext, modelContext),
                                   isActive: $isNavigatingToMainView) {
                        EmptyView()
                    }
                    
                    // NavigationLink to WelcomeView
                    NavigationLink(destination: WelcomeView(userGoals: $userGoals)
                        .environment(\.modelContext, modelContext),
                                   isActive: $isNavigatingToWelcomeView) {
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
            .onChange(of: viewModel.isSignedIn) { isSignedIn in
                if isSignedIn {
                    if viewModel.skippedSignIn || viewModel.isNewUser {
                        isNavigatingToWelcomeView = true
                    } else {
                        isNavigatingToMainView = true
                    }
                }
            }
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
