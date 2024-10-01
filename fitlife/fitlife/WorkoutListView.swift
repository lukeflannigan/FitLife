//
//  WorkoutListView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/1/24.
//

import SwiftUI
import SwiftData

struct ExerciseSelector: View {
    @Binding var selectedExercise: Exercise
    let exercises: [Exercise]

    var body: some View {
        Picker("Select Exercise", selection: $selectedExercise) {
            ForEach(exercises) { exercise in
                Text(exercise.name).tag(exercise)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct WorkoutEntryForm: View {
    @Binding var workout: Workout
    
    var body: some View {
        Form {
            Section(header: Text("Workout Details")) {
                Stepper("Sets: \(workout.sets)", value: $workout.sets, in: 1...10)
                Stepper("Reps: \(workout.reps)", value: $workout.reps, in: 1...100)
                HStack {
                    Text("Weight:")
                    TextField("Weight", value: $workout.weight, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                DatePicker("Date", selection: $workout.date, displayedComponents: .date)
            }
        }
    }
}

struct WorkoutListView: View {
    @Query private var workouts: [Workout]
    @State private var selectedExercise: Exercise = Exercise.mockExercises[0]
    @State private var newWorkout = Workout(exercise: Exercise.mockExercises[0])
    @State private var showingNewWorkoutForm = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    VStack(alignment: .leading) {
                        Text(workout.exercise.name)
                            .font(.headline)
                        Text("\(workout.sets) sets, \(workout.reps) reps, \(String(format: "%.1f", workout.weight)) lbs")
                            .font(.subheadline)
                        Text(workout.date, style: .date)
                            .font(.caption)
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewWorkoutForm = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewWorkoutForm) {
                NavigationView {
                    VStack {
                        ExerciseSelector(selectedExercise: $selectedExercise, exercises: Exercise.mockExercises)
                        WorkoutEntryForm(workout: $newWorkout)
                    }
                    .navigationTitle("New Workout")
                    .navigationBarItems(
                        leading: Button("Cancel") { showingNewWorkoutForm = false },
                        trailing: Button("Save") {
                            saveNewWorkout()
                            showingNewWorkoutForm = false
                        }
                    )
                }
            }
        }
    }
    
    private func deleteWorkouts(at offsets: IndexSet) {
        for index in offsets {
            let workout = workouts[index]
            modelContext.delete(workout)
        }
    }
    
    private func saveNewWorkout() {
        newWorkout.exercise = selectedExercise
        modelContext.insert(newWorkout)
        newWorkout = Workout(exercise: selectedExercise)
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView()
    }
}
