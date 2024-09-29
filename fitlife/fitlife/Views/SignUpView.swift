// SignInView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Create Account")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    CustomTextField(text: $email, placeholder: "Email", imageName: "envelope")
                    CustomTextField(text: $password, placeholder: "Password", imageName: "lock", isSecure: true)
                    CustomTextField(text: $confirmPassword, placeholder: "Confirm Password", imageName: "lock", isSecure: true)
                    
                    Button("Sign Up") {
                        // Sign up functionality to be implemeted later
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    
                    NavigationLink("Already have an account? Log In", destination: SignInView())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .imageScale(.large)
        }
    }
}
