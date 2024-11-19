//
//  WorkoutLibraryView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/28/24.
//

import SwiftUI
import SwiftData

struct WorkoutLibraryView: View {
    // Fetch workouts from user data
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    
    // State for showing the current workout
    @State private var showingWorkout = false
    @State private var showingExerciseLibrary = false
    @Environment(\.currentWorkout) var currentWorkout

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    Button(action: {
                        showingExerciseLibrary = true
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
                    .sheet(isPresented: $showingExerciseLibrary) {
                        NavigationView {
                            ExerciseLibraryView(workout: currentWorkout.wrappedValue ?? Workout(name: "New Workout"))
                        }
                    }
                    ForEach(workouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            WorkoutCard(workout: workout)
                                .padding(.horizontal)
                        }
                        .swipeActions() {
                            // Edit button
                            Button("Edit") {
                                selectedWorkout = workout
                                workoutName = workout.name
                                isEditWorkoutAlertShowing = true
                            }
                            .tint(.blue)
                            
                            // Delete button
                            Button("Delete", role: .destructive) {
                                deleteWorkout(workout)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Workout Library")
            .toolbar {
                Button(action: {
                    if let existingWorkout = workouts.first(where: { !$0.completed}) {
                        currentWorkout.wrappedValue = existingWorkout
                    } else {
                        let newWorkout = Workout(name: "New Workout")
                        addNewWorkout(newWorkout: newWorkout)
                    }
                    showingWorkout = true
                }) {
                    if let existingWorkout = workouts.first(where: { !$0.completed}) {
                        Text("Resume Workout")
                    } else {
                        Text("Start New Workout")
                    }
                    
                }
                .sheet(isPresented: $showingWorkout) {
                    CurrentWorkoutView(currentWorkout: currentWorkout)
                }
            }
        }
    }
    
    // MARK: - Start New Workout Function
    func addNewWorkout(newWorkout: Workout) {
        modelContext.insert(newWorkout)
        currentWorkout.wrappedValue = newWorkout
        }
    
    
    // Function to delete a workout
    private func deleteWorkout(_ workout: Workout) {
        modelContext.delete(workout)
    }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    var workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(workout.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Spacer()
            }
            
            // Date
            Text("Created on \(workout.date, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Number of Exercises
            Text("\(workout.workoutExercises.count) Exercises")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    WorkoutLibraryView()
        .modelContainer(for: [Workout.self, Exercise.self]) // Needed for preview with SwiftData
}
