// SignInView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 30) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign Up") {
                    // Sign up functionality to be implemeted later
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}
