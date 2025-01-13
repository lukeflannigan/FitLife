// ProfileView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var userGoals: [UserGoals]
    var userGoal: UserGoals? { userGoals.first }
    
    @State private var showEditProfile: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    settingsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 80) // To account for tab bar.
            }
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 15) {
            if let profilePicture = userGoal?.profilePicture,
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
            
            Text(userGoal?.userProfile.name ?? "")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(.primary)
            
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
    
    private var settingsSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Settings")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 10) {
                // Placeholder for Notifications
                NavigationLink(destination: NotificationSettingsView()) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(Color("GradientStart"))
                            .frame(width: 24, height: 24)
                        Text("Notifications")
                            .font(.custom("Poppins-Medium", size: 16))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                }
                
                // Log Out Button
                Button(action: logOut) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                            .foregroundColor(Color("GradientStart"))
                            .frame(width: 24, height: 24)
                        Text("Log Out")
                            .font(.custom("Poppins-Medium", size: 16))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private func logOut() {
        print("Log Out tapped!")
        UserDefaults.standard.removeObject(forKey: "userSession")
        UserDefaults.standard.set(false, forKey: "skippedSignIn")
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: OpeningView())
            window.makeKeyAndVisible()
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
}
