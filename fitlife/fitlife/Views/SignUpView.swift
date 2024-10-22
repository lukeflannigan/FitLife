// SignUpView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignUpView: View {
//    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var userGoals = UserGoals(name: "")
    @State private var showWelcomeView = false  // Flag for showing WelcomeView
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerSection
                        formSection
                        signUpButton
                        signInSection
                    }
                    .padding(.horizontal, 30)
                }
                .fullScreenCover(isPresented: $showWelcomeView) {
                    WelcomeView(userGoals: $userGoals)  // Show WelcomeView as a full screen cover
                        .navigationBarBackButtonHidden(true)  // Ensure no back button in WelcomeView
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Create Account")
                .font(.system(size: 32, weight: .bold))
            Text("Sign up to get started!")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .foregroundColor(.white)
        .padding(.top, 50)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $viewModel.email, placeholder: "Email", imageName: "envelope")
            CustomTextField(text: $viewModel.password, placeholder: "Password", imageName: "lock", isSecure: true)
            CustomTextField(text: $viewModel.confirmPassword, placeholder: "Confirm Password", imageName: "lock", isSecure: true)
        }
    }
    
    private var signUpButton: some View {
        Button(action: {
            viewModel.signUp()
            if viewModel.userSession != nil {
                showWelcomeView = true  // Trigger WelcomeView as full screen cover
            }
        }) {
            Text("Sign Up")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.white)
                .cornerRadius(12)
        }
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
