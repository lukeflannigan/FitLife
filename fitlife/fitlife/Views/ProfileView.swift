// ProfileView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 80) // To account for tab bar.
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Header Section
    private var headerSection: some View {
        VStack(spacing: 15) {
            // Profile Picture
            Image("profile_picture")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                )
                .shadow(radius: 10)
            
            // Username
            Text("Dr. Lehr")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(.primary)
            
            // Edit Profile Button
            Button(action: {
            }) {
                Text("Edit Profile")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(Color("GradientStart"))
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
