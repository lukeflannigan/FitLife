//
//  WorkoutListView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/1/24.
//

import SwiftUI
import SwiftData

struct WorkoutItem: View {
    var workout: Workout // passing in workout object
    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.exercise.name)
            Text("Sets: \(workout.sets), Reps: \(workout.reps), Weight: \(String(format: "%.1f", workout.weight)) lbs")
        }
    }
}


struct NewWorkoutForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var workouts: [Workout]
    @State private var currExercise = Exercise()
    @State private var inputSetCount: Int? = nil
    @State private var inputRepCount: Int? = nil
    @State private var inputWeight: Double? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input Exercise")) {
                    TextField("Exercise Name", text: $currExercise.name)
                }
                Section(header: Text("Details")) {
                    // sets
                    Stepper(value: Binding(
                        get: { inputSetCount ?? 0 },
                        set: { inputSetCount = $0 }
                    ),in: 0...10) {
                        TextField("Sets", value: $inputSetCount, format: .number)
                            .keyboardType(.numberPad)
                    }
                    // reps
                    Stepper(value: Binding(
                        get: { inputRepCount ?? 0 },
                        set: { inputRepCount = $0 }
                    ),in: 0...10) {
                        TextField("Reps", value: $inputRepCount, format: .number)
                            .keyboardType(.numberPad)
                    }
                    // weight
                    Stepper(value: Binding(
                        get: { inputWeight ?? 0 },
                        set: { inputWeight = $0 }
                    ), in: 0...100, step: 2.5) {
                        TextField("Weight", value: $inputWeight, format: .number)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationBarTitle("Add Exercise")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newWorkout = Workout(exercise: currExercise, sets: inputSetCount ?? 0, reps: inputRepCount ?? 0, weight: inputWeight ?? 0.0)
                        workouts.append(newWorkout)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}


struct WorkoutsView: View {
    @State private var workouts: [Workout] = []
    @State private var showingNewWorkoutForm = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Daily Split")
                    .font(.custom("Poppins-Bold", size: 28))
                Spacer()
                List {
                    ForEach(workouts) { workout in
                        WorkoutItem(workout: workout)
                    }
                    .onDelete(perform: deleteWorkouts)

                    Button(action: { showingNewWorkoutForm.toggle() }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add New Exercise")
                                .font(.custom("Poppins-Bold", size: 16))
                        }
                        .frame(maxWidth: 300)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    }
                    .padding(.vertical)
                }
                .listStyle(PlainListStyle())
            }
            .padding()
            .sheet(isPresented: $showingNewWorkoutForm) {
                NewWorkoutForm(workouts: $workouts)
            }
        }
    }
    
    private func deleteWorkouts(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }
    
}

#Preview {
    WorkoutsView()
}