// SignUpView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var userGoals = UserGoals(name: "")
    @State private var showWelcomeView = false  // Flag for showing WelcomeView
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerSection
                        signInWithAppleButton
                        signInSection
                    }
                    .padding(.horizontal, 30)
                }
                .fullScreenCover(isPresented: $showWelcomeView) {
                    WelcomeView(userGoals: $userGoals)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Create Account")
                .font(.system(size: 32, weight: .bold))
            Text("Sign in with Apple to get started!")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .foregroundColor(.white)
        .padding(.top, 50)
    }
    
    private var signInWithAppleButton: some View {
        SignInWithAppleButton(
            onRequest: { request in
                viewModel.signInWithApple()
            },
            onCompletion: { result in
                if viewModel.userSession != nil {
                    showWelcomeView = true
                }
            }
        )
        .frame(width: 280, height: 50)
        .signInWithAppleButtonStyle(.whiteOutline)
        .padding()
    }
    
    private var signInSection: some View {
        HStack {
            Text("Already have an account?")
            NavigationLink("Log In", destination: SignInView())
        }
        .font(.system(size: 14))
        .foregroundColor(.white)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
        }
    }
}
