//
//  CurrentWorkoutView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/14/24.
//
import Foundation
import SwiftUI
import SwiftData

struct CurrentWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedExercises = Set<UUID>()
    @State private var isSelectingExercises = false
    @Binding var currentWorkout: Workout?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let currentWorkout = currentWorkout {
            VStack {
            Text("Current Workout")
                .font(.headline)
                .padding()
            List {
                ForEach(currentWorkout.workoutExercises) { workoutExercise in
                    WorkoutExerciseView(workout: currentWorkout, workoutExercise: workoutExercise)
                }
                Button(action: {
                    isSelectingExercises = true
                }) {
                    HStack {
                        Image(systemName: "book.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        Text("Browse Exercises")
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
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
