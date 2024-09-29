// SignInView.swift
// Created by Luke Flannigan on 9/26/24

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    CustomTextField(text: $email, placeholder: "Email", imageName: "envelope")
                    CustomTextField(text: $password, placeholder: "Password", imageName: "lock", isSecure: true)
                    
                    Button("Sign In") {
                        // Sign in functionality to be implemented
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    
                    NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
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

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let imageName: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.white)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
        .foregroundColor(.white)
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
