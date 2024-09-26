//
//  SignInView.swift
//  fitlife
//
//  Created by Luke Flannigan on 9/26/24.
//
import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            // White Card
            VStack(alignment: .leading, spacing: 20) {
                // "Sign In" Title
                Text("Sign In")
                    .font(.custom("Poppins-Bold", size: 40))
                    .foregroundColor(.black)
                    .padding(.top, 40)
                    .padding(.leading, 20)

                // Email and Password Fields
                VStack(spacing: 20) {
                    TextField("Email Address", text: $email)
                        .font(.custom("Poppins-Regular", size: 14))
                        .padding()
                        .frame(height: 48)
                        .background(Color.black.opacity(0.04))
                        .cornerRadius(30)
                        .padding(.horizontal, 20)

                    SecureField("Password", text: $password)
                        .font(.custom("Poppins-Regular", size: 14))
                        .padding()
                        .frame(height: 48)
                        .background(Color.black.opacity(0.04))
                        .cornerRadius(30)
                        .padding(.horizontal, 20)
                }

                // "Sign In" Button
                Button(action: {
                    // Handle sign in
                }) {
                    Text("Sign In")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.black)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 20)

                Spacer()
                    .frame(height: 40)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}


