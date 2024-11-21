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
    @State private var showingExerciseCreation = false
    @Environment(\.currentWorkout) var currentWorkout
    
    // Animation state
    @State private var isScrolled = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if workouts.isEmpty {
                            EmptyStateView()
                        } else {
                            ForEach(workouts) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    WorkoutCard(workout: workout)
                                }
                                .buttonStyle(WorkoutCardButtonStyle())
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteWorkout(workout)
                                    } label: {
                                        Label("Delete Workout", systemImage: "trash")
                                    }
                                }
                                .swipeActions {
                                    Button("Delete", role: .destructive) {
                                        withAnimation {
                                            deleteWorkout(workout)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 90)
                }
                .scrollIndicators(.hidden)
                
                // Action Button Container
                VStack(spacing: 0) {
                    Button(action: {
                        if let existingWorkout = workouts.first(where: { !$0.completed}) {
                            currentWorkout.wrappedValue = existingWorkout
                        } else {
                            let newWorkout = Workout(name: "New Workout")
                            addNewWorkout(newWorkout: newWorkout)
                        }
                        showingWorkout = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                            Text(workouts.first(where: { !$0.completed}) != nil ? "Resume Workout" : "Start Workout")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(26)
                        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                }
                .padding(.bottom, 49)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                )
            }
            .sheet(isPresented: $showingWorkout) {
                CurrentWorkoutView(currentWorkout: currentWorkout)
            }
            .navigationTitle("Workout Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ExerciseLibraryView(workout: Workout(name: "temp"))) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
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
        try? modelContext.save()
    }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    var workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(workout.workoutExercises.count)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primary)
                    + Text("\nExercises")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(workout.workoutExercises.prefix(4)) { exercise in
                        ExerciseTag(name: exercise.exercise?.name ?? "Unknown")
                    }
                    if workout.workoutExercises.count > 4 {
                        Text("+\(workout.workoutExercises.count - 4)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

struct ExerciseTag: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

struct WorkoutCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("No workouts yet")
                .font(.system(size: 20, weight: .semibold))
            Text("Start your first workout to begin tracking your progress")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

// MARK: - Preview
#Preview {
    WorkoutLibraryView()
        .modelContainer(for: [Workout.self, Exercise.self])
}
