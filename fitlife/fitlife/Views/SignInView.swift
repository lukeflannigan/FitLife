// SignInView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 30) {
                Text("Welcome Back")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign In") {
                    // Sign in functionality to be implemented
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

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}
