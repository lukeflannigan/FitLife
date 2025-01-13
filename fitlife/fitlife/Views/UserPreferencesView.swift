//
//  UserPreferencesView.swift
//  fitlife
//
//  Created by Jonas Tuttle on 11/24/24.
//

import SwiftUI
import UserNotifications

struct UserPreferencesView: View {
    @State private var useMetric: Bool = true // Default to metric for this example
    @State private var dietaryRestrictions: String = "" // Placeholder for restrictions
    @State private var notificationsEnabled: Bool = false // Toggle for notifications

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
            
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                .font(.custom("Poppins-Medium", size: 18))
                .padding(.vertical, 10)
                .onChange(of: notificationsEnabled) { isEnabled in
                    handleNotificationToggle(isEnabled: isEnabled)
                }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(UIColor.systemBackground))
        .navigationTitle("User Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleNotificationToggle(isEnabled: Bool) {
        let center = UNUserNotificationCenter.current()
        if isEnabled {
            // Schedule notifications
            let dummyProgress = DailyProgress(
                currentDailyIntake: [
                    DailyIntake(calories: 500, protein: 20, carbs: 50, fats: 10),
                    DailyIntake(calories: 300, protein: 15, carbs: 40, fats: 8)
                ],
                caloriesGoal: 2000,
                proteinGoal: 150,
                fatsGoal: 50,
                carbsGoal: 200
            )
            NotificationScheduler.shared.scheduleProgressNotifications(for: dummyProgress)
            print("Notifications enabled.")
        } else {
            // Cancel notifications
            center.removeAllPendingNotificationRequests()
            print("Notifications disabled.")
        }
    }
}

struct UserPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserPreferencesView()
        }
    }
}
