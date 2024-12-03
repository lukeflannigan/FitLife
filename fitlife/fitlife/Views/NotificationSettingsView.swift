//
//  NotificationSettingsView.swift
//  fitlife
//
//  Created by Jonas Tuttle on 11/24/24.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    // Persisted key for the toggle state
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false

    var body: some View {
        Form {
            Section(header: Text("Notifications")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.secondary)) {
                
                Toggle("Enable Daily Progress Notification", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { isEnabled in
                        handleNotificationToggle(isEnabled: isEnabled)
                    }
            }
        }
        .navigationTitle("Notification Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Ensure the toggle reflects the stored state on app launch
            handleNotificationToggle(isEnabled: notificationsEnabled)
        }
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
