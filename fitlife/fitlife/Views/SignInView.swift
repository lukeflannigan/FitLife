// SignInView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignInView: View {
//    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var navigateToMain = false  // Navigation flag
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerSection
                    formSection
                    forgotPasswordButton
                    signInButton
                    signUpSection
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
            }
            
            // Use FullScreenCover to navigate to MainView, removing SignInView from the view hierarchy
            .fullScreenCover(isPresented: $navigateToMain) {
                MainView()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Welcome Back")
                .font(.system(size: 32, weight: .bold))
            Text("Sign in to continue")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .foregroundColor(.white)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $viewModel.email, placeholder: "Email", imageName: "envelope")
            CustomTextField(text: $viewModel.password, placeholder: "Password", imageName: "lock", isSecure: true)
        }
    }
    
    private var forgotPasswordButton: some View {
        Button("Forgot Password?") {
            viewModel.sendPasswordReset()
        }
        .font(.system(size: 14))
        .foregroundColor(.white)
    }
    
    private var signInButton: some View {
        VStack {
            Button(action: {
                viewModel.signIn()
                if viewModel.userSession != nil {
                    navigateToMain = true  // Trigger navigation to MainView
                }
            }) {
                Text("Sign In")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            
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
