//
//  SplashView.swift
//  fitlife
//
//  Created by Jonas Tuttle on 10/4/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct SplashView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var currentWorkout: Workout?
    @State private var isActive = false  // Flag to track when to navigate
    @State private var destination: AnyView? = nil
    var body: some View {
        ZStack {
            GradientBackground()
            
            if isActive, let destination = destination { destination
            } else {
                VStack {
                    Text("FitLife")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                checkUserStatus()
            }
            loadCurrentWorkout()
//            scheduleTestNotification()
        }
    }
    
//    private func scheduleTestNotification() {
//        // Step 1: Request authorization
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted && error == nil {
//                // Step 2: Create the notification content
//                let content = UNMutableNotificationContent()
//                content.title = "Test Notification"
//                content.body = "This is a test to confirm notifications are working!"
//                content.sound = .default
//                
//                // Step 3: Set the trigger time (5 seconds)
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                
//                // Step 4: Create the request
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//                
//                // Step 5: Add the request to the notification center
//                UNUserNotificationCenter.current().add(request) { error in
//                    if let error = error {
//                        print("Error scheduling test notification: \(error)")
//                    }
//                }
//            } else {
//                print("Notification permissions not granted: \(String(describing: error))")
//            }
//        }
//    }
    private func loadCurrentWorkout() {
            let fetchDescriptor = FetchDescriptor<Workout>(
                predicate: #Predicate {$0.completed == false},
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            do {
                let incompleteWorkouts = try modelContext.fetch(fetchDescriptor)
                currentWorkout = incompleteWorkouts.first
                print("Current workout loaded: \(currentWorkout?.name ?? "None")")
            } catch {
                print("Failed to fetch current workout: \(error)")
            }
        }

    private func checkUserStatus() {
        if let _ = UserDefaults.standard.string(forKey: "userSession") {
            self.destination = AnyView(MainView().environment(\.modelContext, modelContext)
                .environment(\.currentWorkout, $currentWorkout)
)
        } else if UserDefaults.standard.bool(forKey: "skippedSignIn") {
            self.destination = AnyView(MainView().environment(\.modelContext, modelContext)
                .environment(\.currentWorkout, $currentWorkout)
)
        } else {
            self.destination = AnyView(OpeningView()
                .environment(\.modelContext, modelContext)
                .environment(\.currentWorkout, $currentWorkout)
)
        }
        withAnimation {
            self.isActive = true
        }
    }
}

//struct SplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView()
//    }
//}
