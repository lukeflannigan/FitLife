// SignInView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignInView: View {
    // Will want to transition to viewmodel eventually 
    @State private var email = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode
    
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
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
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
            CustomTextField(text: $email, placeholder: "Email", imageName: "envelope")
            CustomTextField(text: $password, placeholder: "Password", imageName: "lock", isSecure: true)
        }
    }
    
    private var forgotPasswordButton: some View {
        Button("Forgot Password?") {
            // Eventually will need to handle forgot passsword function
        }
        .font(.system(size: 14))
        .foregroundColor(.white)
    }
    
    private var signInButton: some View {
        Button(action: signIn) {
            Text("Sign In")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.white)
                .cornerRadius(12)
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
    
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .imageScale(.large)
        }
    }
    
    private func signIn() {
        print("Sign in with email: \(email)")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}
