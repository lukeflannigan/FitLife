//
//  WorkoutLibraryView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/28/24.
//

import SwiftUI
import SwiftData

struct WorkoutLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isCreateWorkoutAlertShowing = false
    @State private var workoutName: String = ""
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(workouts) { workout in
                        NavigationLink(destination: WorkoutsView(workout: workout)) {
                            WorkoutCard(workout: workout)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Workout Library")
            .navigationBarItems(trailing:
                                    Button(action: { isCreateWorkoutAlertShowing.toggle() }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.darkGray))
            })
            .alert("Create New Workout", isPresented: $isCreateWorkoutAlertShowing) {
                TextField("Workout Name", text: $workoutName)
                
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    let newWorkout = Workout(name: workoutName, exercises: [], date: Date())
                    modelContext.insert(newWorkout)
                    workoutName = ""
                }
            } message: {
                Text("Enter the name of your workout.")
            }
        }
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
            Text("\(workout.exercises.count) Exercises")
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
