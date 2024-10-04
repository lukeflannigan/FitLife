// SignUpView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignUpView: View {
    // Will want to transition to viewmodel eventually
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userGoals = UserGoals(name: "")  // Create a UserGoals instance
    @State private var navigateToWelcome = false
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
            
            // NavigationLink for WelcomeView triggered by signUpButton
            NavigationLink(destination: WelcomeView(userGoals: $userGoals), isActive: $navigateToWelcome) {
                EmptyView()
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
            CustomTextField(text: $email, placeholder: "Email", imageName: "envelope")
            CustomTextField(text: $password, placeholder: "Password", imageName: "lock", isSecure: true)
            CustomTextField(text: $confirmPassword, placeholder: "Confirm Password", imageName: "lock", isSecure: true)
        }
    }
    
    private var signUpButton: some View {
        Button(action: signUp) {
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
    
    private func signUp() {
        // Simulate signing up and navigate to WelcomeView
        print("Sign up with email: \(email)")
        navigateToWelcome = true
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}

