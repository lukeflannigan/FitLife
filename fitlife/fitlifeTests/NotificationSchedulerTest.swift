//
//  NotificationSchedulerTest.swift
//  fitlife
//
//  Created by Jonas Tuttle on 11/27/24.
//

import XCTest
import UserNotifications
@testable import fitlife

class NotificationSchedulerTests: XCTestCase {
    func testProgressNotifications() {
        // Step 1: Initialize test data
        let dailyProgress = DailyProgress(
            currentDailyIntake: [
                DailyIntake(calories: 500, protein: 20, carbs: 50, fats: 10, name: "Breakfast"),
                DailyIntake(calories: 300, protein: 15, carbs: 40, fats: 8, name: "Snack")
            ],
            caloriesGoal: 2000,
            proteinGoal: 150,
            fatsGoal: 50,
            carbsGoal: 200
        )

        // Step 2: Schedule notifications
        NotificationScheduler.shared.scheduleProgressNotifications(for: dailyProgress)

        // Step 3: Verify pending notifications
        let expectation = self.expectation(description: "Check scheduled notifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            // Debug log: Output the number and details of pending notifications
            print("Pending Notifications Count: \(requests.count)")
            for request in requests {
                print("Notification ID: \(request.identifier)")
                print("Notification Body: \(request.content.body)")
            }

            // Assertions
            XCTAssertGreaterThan(requests.count, 0, "No notifications were scheduled.")
            
            let progressNotifications = requests.filter { $0.identifier.contains("dailyProgressNotification") }
            XCTAssertEqual(progressNotifications.count, 5, "Expected 5 progress notifications to be scheduled.")

            if let firstNotification = progressNotifications.first {
                XCTAssert(firstNotification.content.body.contains("You are currently"), "Notification body is incorrect.")
            }
            expectation.fulfill()
        }

        // Step 4: Wait for expectations
        waitForExpectations(timeout: 5, handler: nil)
    }
}
