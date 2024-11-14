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
                        Text("Browse Exercises")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
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
                    Text("Start New Workout")
                }
                .sheet(isPresented: $showingWorkout) {
                    CurrentWorkoutView(currentWorkout: currentWorkout)
                }
            }
        }
    }
    
    // MARK: - Start New Workout Function
    func addNewWorkout(newWorkout: Workout) {
            let newWorkout = Workout(name: "New Workout")
            modelContext.insert(newWorkout)
            currentWorkout.wrappedValue = newWorkout
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
            Text(workout.date, style: .date)
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
