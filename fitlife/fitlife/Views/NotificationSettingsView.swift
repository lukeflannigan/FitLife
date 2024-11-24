//
//  NotificationSettingsView.swift
//  fitlife
//
//  Created by Jonas Tuttle on 11/24/24.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var useMetric: Bool = true // Default to metric for this example
    @State private var dietaryRestrictions: String = "" // Placeholder for restrictions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("User Preferences")
                .font(.custom("Poppins-Bold", size: 28))
                .padding(.top, 20)
            
            Toggle("Use Metric System", isOn: $useMetric)
                .font(.custom("Poppins-Medium", size: 18))
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Dietary Restrictions")
                    .font(.custom("Poppins-SemiBold", size: 18))
                TextField("Enter dietary restrictions", text: $dietaryRestrictions)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(UIColor.systemBackground))
        .navigationTitle("User Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationSettingsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserPreferencesView()
        }
    }
}
