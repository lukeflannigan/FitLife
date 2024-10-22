// SignUpView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var userGoals = UserGoals(name: "")  // Define userGoals
    @State private var navigateToWelcome = false  // Navigation flag
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
            
            NavigationLink(destination: WelcomeView(userGoals: $userGoals), isActive: $navigateToWelcome) {
                EmptyView()
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
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
                navigateToWelcome = true
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
    
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .imageScale(.large)
        }
    }
}
