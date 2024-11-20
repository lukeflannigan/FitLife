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
    @StateObject private var viewModel = ExerciseDataViewModel()
    @Binding var currentWorkout: Workout?
    @State private var isActive = false
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
                loadCurrentWorkout()
                fetchExercises()
            }
        }
    }
    
    private func fetchExercises() {
        Task {
            await viewModel.loadExercises(modelContext: modelContext)
        }
    }
    
    private func loadCurrentWorkout() {
        let fetchDescriptor = FetchDescriptor<Workout>(
            predicate: #Predicate { $0.completed == false },
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
        let userSession = UserDefaults.standard.string(forKey: "userSession")
        let skippedSignIn = UserDefaults.standard.bool(forKey: "skippedSignIn")
        
        if userSession != nil {
            self.destination = AnyView(
                MainView()
                    .environment(\.modelContext, modelContext)
                    .environment(\.currentWorkout, $currentWorkout)
            )
        } else if skippedSignIn {
            self.destination = AnyView(
                MainView()
                    .environment(\.modelContext, modelContext)
                    .environment(\.currentWorkout, $currentWorkout)
            )
        } else {
            self.destination = AnyView(
                OpeningView()
                    .environment(\.modelContext, modelContext)
                    .environment(\.currentWorkout, $currentWorkout)
            )
        }
        withAnimation {
            self.isActive = true
        }
    }
}
