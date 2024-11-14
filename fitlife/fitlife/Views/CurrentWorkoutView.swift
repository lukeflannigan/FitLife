//
//  CurrentWorkoutView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/14/24.
//

import SwiftUI
import SwiftData

struct CurrentWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedExercises = Set<String>()
    @State private var isSelectingExercises = false
    @Binding var currentWorkout: Workout?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("Current Workout")
        if let currentWorkout = currentWorkout {
            VStack {
            Text("Current Workout")
                .font(.headline)
                .padding()
            List {
                ForEach(currentWorkout.workoutExercises) { workoutExercise in
                    WorkoutExerciseView(workout: currentWorkout, workoutExercise: workoutExercise)
                }
                HStack {
                    Button(action: {
                        isSelectingExercises = true
                    }) {
                        Text("Add Exercises")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            
            .sheet(isPresented: $isSelectingExercises, content: {
                NavigationStack {
                    ExerciseSelectionView(selectedExercises: $selectedExercises, currentWorkout: $currentWorkout)
                }
            })
                HStack {
                    Button(role: .destructive, action: {
                        modelContext.delete(currentWorkout)
                        self.currentWorkout = nil
                        dismiss()
                    }) {
                        Text("Cancel Workout")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    if !currentWorkout.workoutExercises.isEmpty {
                        Button(action: {
                            currentWorkout.completed = true
                            self.currentWorkout = nil
                            dismiss()
                        }) {
                            Text("Finish Workout")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
        }
        } else {
            Text("No current workout")
        }
    }
}

//#Preview {
//    CurrentWorkoutView()
//}
