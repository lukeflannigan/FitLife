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
                ExerciseSet.self
            )
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashView()
                    .modelContainer(modelContainer)
                    .environment(\.currentWorkout, $currentWorkout)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                requestNotificationPermissions()
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
}

