//
//  NotificationScheduler.swift
//  fitlife
//
//  Created by Jonas Tuttle on 11/27/24.
//

import UserNotifications

class NotificationScheduler {
    static let shared = NotificationScheduler()

    func scheduleProgressNotifications(for progress: DailyProgress) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyProgressNotification"])

        let content = UNMutableNotificationContent()
//        let percentage = progress.getCalorieProgressPercentage()
        content.title = "Keep Going!"
//        content.body = "You are currently \(percentage)% done with your daily calorie goal. Eat!"
        content.sound = .default

        // Schedule notification at specific times
        let times = [9, 12, 15, 18, 21] // Notify at 9 AM, 12 PM, etc.
        for time in times {
            let dateComponents = DateComponents(hour: time, minute: 0)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "dailyProgressNotification_\(time)", content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
}
