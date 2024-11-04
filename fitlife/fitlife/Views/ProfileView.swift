// ProfileView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var userGoals: [UserGoals]
    
    // Will need to connect this to real data later
    // Just using this to test view works
    @State private var userEmail: String = "email@email.com"
    @State private var userPhone: String = "+1 (123) 456-7890"
    
    @State private var showEditProfile: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                personalInfoSection
                settingsSection
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
            if let profilePicture = userGoals.first?.profilePicture,
               let uiImage = UIImage(data: profilePicture) {
                Image(uiImage: uiImage)
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
            } else {
                Image(systemName: "person.circle.fill")
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
            }
            
            // Username
            Text(userGoals.first?.name ?? "")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(.primary)
            
            // Edit Profile Button
            Button(action: {
                showEditProfile.toggle()
            }) {
                Text("Edit Profile")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(Color("GradientStart"))
            }
            .sheet(isPresented: $showEditProfile) {
                if let userGoal = userGoals.first {
                    EditProfileView(userGoals: userGoal)
                }
            }
        }
    }
    
    // Personal Info Section
    private var personalInfoSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Personal Information")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 10) {
                InfoRow(iconName: "envelope.fill", title: "Email", value: userEmail)
                InfoRow(iconName: "phone.fill", title: "Phone", value: userPhone)
            }
        }
    }
    
    // Settings Section
    private var settingsSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Settings")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 10) {
                SettingsRow(iconName: "lock.fill", title: "Change Password") {
                    // Change password
                }
                SettingsRow(iconName: "bell.fill", title: "Notifications") {
                    // Manage notifications
                }
                SettingsRow(iconName: "hand.raised.fill", title: "Privacy Settings") {
                    // Manage privacy
                }
            }
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
}
