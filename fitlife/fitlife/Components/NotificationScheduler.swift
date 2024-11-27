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
        content.sound = .default

        // Schedule notifications at specific times
        let notificationTimes = [9, 12, 15, 18, 21] // Notify at 9 AM, 12 PM, etc.

        for time in notificationTimes {
            var dateComponents = DateComponents()
            dateComponents.hour = time
            dateComponents.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "dailyProgressNotification_\(time)", content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification for \(time): \(error)")
                }
            }
        }
    }
}
