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
    @State private var isEditingName = false
    @State private var tempName: String = ""
    
    var body: some View {
        if let currentWorkout = currentWorkout {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        if isEditingName {
                            HStack(spacing: 8) {
                                TextField("Workout Name", text: $tempName)
                                    .font(.system(size: 24, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(.plain)
                                    .frame(width: 240)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .clipShape(Capsule())
                                
                                Button(action: { saveWorkoutName(currentWorkout) }) {
                                    Text("Save")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                        } else {
                            HStack(spacing: 8) {
                                Text(currentWorkout.name)
                                    .font(.system(size: 24, weight: .bold))
                                
                                Button(action: {
                                    tempName = currentWorkout.name
                                    isEditingName = true
                                }) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 20))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Text(currentWorkout.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                
                // Exercise List
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(currentWorkout.workoutExercises) { workoutExercise in
                            WorkoutExerciseView(workout: currentWorkout, workoutExercise: workoutExercise)
                                .padding(.horizontal, 20)
                        }
                        
                        // Add Exercise Button
                        Button(action: { isSelectingExercises = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.black)
                                
                                Text("Add Exercises")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                // Bottom Action Bar
                VStack(spacing: 12) {
                    Divider()
                    
                    HStack(spacing: 16) {
                        // Cancel Button
                        Button(role: .destructive, action: {
                            modelContext.delete(currentWorkout)
                            self.currentWorkout = nil
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Cancel")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(.systemGray6))
                            .foregroundColor(.red)
                            .cornerRadius(26)
                        }
                        
                        // Finish Button
                        if !currentWorkout.workoutExercises.isEmpty {
                            Button(action: {
                                currentWorkout.completed = true
                                self.currentWorkout = nil
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Complete")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(26)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemBackground))
            }
            .sheet(isPresented: $isSelectingExercises) {
                NavigationStack {
                    ExerciseSelectionView(selectedExercises: $selectedExercises, currentWorkout: $currentWorkout)
                }
            }
        } else {
            // Empty State
            VStack(spacing: 16) {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.secondary)
                Text("No Active Workout")
                    .font(.system(size: 20, weight: .semibold))
                Text("Start a new workout to begin tracking your exercises")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
        }
    }
    
    private func saveWorkoutName(_ workout: Workout) {
        workout.name = tempName
        try? modelContext.save()
        isEditingName = false
    }
}

//#Preview {
//    CurrentWorkoutView()
//}
