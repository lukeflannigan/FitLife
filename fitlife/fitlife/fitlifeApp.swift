//
//  fitlifeApp.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/24/24.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct YourApp: App {
    let modelContainer: ModelContainer
    @State var currentWorkout: Workout? = nil
    @Environment(\.scenePhase) var scenePhase

    init() {
        do {
            modelContainer = try ModelContainer(
                for: UserGoals.self,
                BodyMetrics.self,
                UserProfile.self,
                Workout.self,
                Exercise.self,
                WorkoutExercise.self,
                ExerciseSet.self,
                DailyIntake.self,
                DailyProgress.self
            )
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashView(currentWorkout: $currentWorkout)
                    .modelContainer(modelContainer)
                    .environment(\.currentWorkout, $currentWorkout)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                requestNotificationPermissions()
                scheduleProgressNotifications() // Reschedule notifications when app becomes active
            }
        }
    }
    
    // Request notification permissions
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("User denied notification permissions: \(String(describing: error))")
            }
        }
    }
    
    // Schedule progress notifications
    private func scheduleProgressNotifications() {
        // Pass in the actual DailyProgress object; modify as needed
        let dummyProgress = DailyProgress() // Replace with your actual data source
        dummyProgress.caloriesGoal = 2000
        dummyProgress.currentDailyIntake = [
            DailyIntake(calories: 500, protein: 20, carbs: 50, fats: 10),
            DailyIntake(calories: 300, protein: 15, carbs: 40, fats: 8)
        ]
        NotificationScheduler.shared.scheduleProgressNotifications(for: dummyProgress)
    }
}
