// SignInView.swift
// Created by Luke Flannigan on 9/26/24

//import SwiftUI
//import AuthenticationServices
//
//struct SignInView: View {
//    @StateObject private var viewModel = AuthenticationViewModel()
//    @Environment(\.presentationMode) var presentationMode
//    @State private var navigateToHome = false  // Navigation flag
//    
//    var body: some View {
//        ZStack {
//            GradientBackground()
//            
//            ScrollView {
//                VStack(spacing: 30) {
//                    headerSection
//                    formSection
//                    forgotPasswordButton
//                    signInButton
//                    signInWithAppleButton  // New Apple sign-in button
//                    signUpSection
//                }
//                .padding(.horizontal, 30)
//                .padding(.top, 50)
//            }
//            
//            // NavigationLink to HomeView on successful sign-in
//            NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
//                EmptyView()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: backButton)
//    }
//    
//    private var headerSection: some View {
//        VStack(spacing: 10) {
//            Text("Welcome Back")
//                .font(.system(size: 32, weight: .bold))
//            Text("Sign in to continue")
//                .font(.system(size: 16))
//                .foregroundColor(.white.opacity(0.7))
//        }
//        .foregroundColor(.white)
//    }
//    
//    private var formSection: some View {
//        VStack(spacing: 20) {
//            CustomTextField(text: $viewModel.email, placeholder: "Email", imageName: "envelope")
//            CustomTextField(text: $viewModel.password, placeholder: "Password", imageName: "lock", isSecure: true)
//        }
//    }
//    
//    private var forgotPasswordButton: some View {
//        Button("Forgot Password?") {
//            viewModel.sendPasswordReset()
//        }
//        .font(.system(size: 14))
//        .foregroundColor(.white)
//    }
//    
//    private var signInButton: some View {
//        VStack {
//            Button(action: {
//                viewModel.signIn()
//                if viewModel.userSession != nil {
//                    navigateToHome = true
//                }
//            }) {
//                Text("Sign In")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.black)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 56)
//                    .background(Color.white)
//                    .cornerRadius(12)
//            }
//            
//            if let errorMessage = viewModel.errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .font(.system(size: 14))
//            }
//        }
//    }
//    
//    private var signInWithAppleButton: some View {
//        SignInWithAppleButton(
//            onRequest: { request in
//                viewModel.signInWithApple()
//            },
//            onCompletion: { result in
//                // Handle the result if needed
//            }
//        )
//        .signInWithAppleButtonStyle(.white)  // Apple standard button style
//        .frame(height: 56)
//        .cornerRadius(12)
//    }
//    
//    private var signUpSection: some View {
//        HStack {
//            Text("Don't have an account?")
//            NavigationLink("Sign Up", destination: SignUpView())
//        }
//        .font(.system(size: 14))
//        .foregroundColor(.white)
//    }
//    
//    private var backButton: some View {
//        Button(action: { presentationMode.wrappedValue.dismiss() }) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.white)
//                .imageScale(.large)
//        }
//    }
//}
