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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Profile")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(.primary)
                Text("Welcome, Dr. Lehr")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
