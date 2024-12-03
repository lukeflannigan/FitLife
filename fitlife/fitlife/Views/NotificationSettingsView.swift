//
//  NotificationSettingsView.swift
//  fitlife
//
//  Created by Jonas Tuttle on 11/24/24.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var notificationsEnabled: Bool = false // Toggle for notifications
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Notification Settings")
                .font(.custom("Poppins-Bold", size: 28))
                .padding(.top, 20)
            
            Toggle("Enable Daily Progress Notification", isOn: $notificationsEnabled)
                .font(.custom("Poppins-Medium", size: 18))
                .padding(.vertical, 10)
                .onChange(of: notificationsEnabled) { isEnabled in
                    handleNotificationToggle(isEnabled: isEnabled)
                }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Notification Settings")
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

struct NotificationSettingsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationSettingsView()
        }
    }
}
