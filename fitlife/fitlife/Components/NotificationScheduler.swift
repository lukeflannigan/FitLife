//
//  NotificationScheduler.swift
//  fitlife
//
//  Created by Jonas Tuttle on 11/27/24.
//

import UserNotifications

class NotificationScheduler {
    static let shared = NotificationScheduler()

    /// Schedules daily progress notifications
    /// - Parameter progress: The user's current progress data
    func scheduleProgressNotifications(for progress: DailyProgress) {
        let center = UNUserNotificationCenter.current()

        // Remove any existing progress notifications to avoid duplicates
        center.removePendingNotificationRequests(withIdentifiers: ["dailyProgressNotification"])

        // Create notification content
        let content = UNMutableNotificationContent()
        let percentage = progress.calorieProgressPercentage
        content.title = "Keep Going!"
        content.body = "You are currently \(percentage)% done with your daily calorie goal. Eat!"
//        content.body = "You are currently 60% done with your daily calorie goal. Eat!"

        content.sound = .default

        // Uncomment the following for immediate testing
        /*
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Trigger after 5 seconds

        // Schedule the notification
        let request = UNNotificationRequest(identifier: "dailyProgressNotification_test", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Test notification scheduled successfully.")
            }
        }
        */
    }
}
