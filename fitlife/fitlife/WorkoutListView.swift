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
        VStack() {
            // TODO: implement functionality to display formatted workout object
        }
    }
}


struct NewWorkoutForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var workouts: [Workout]
    @State private var currExercise = Exercise()
    @State private var inputSetCount: Int = 0
    @State private var inputRepCount: Int = 0
    @State private var inputWeight: Double = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Exercise")) {
                    TextField("Exercise Name", text: $currExercise.name)
                }
                Section(header: Text("Details")) {
                    Stepper("Sets: \(inputSetCount)", value: $inputSetCount, in: 0...10)
                    Stepper("Reps: \(inputRepCount)", value: $inputRepCount, in: 0...10)
                    Stepper("Weight: \(inputWeight)", value: $inputWeight, in: 0...100)
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
                        let newWorkout = Workout(exercise: currExercise, sets: inputSetCount, reps: inputRepCount, weight: inputWeight)
                        workouts.append(newWorkout)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }
    }
}


struct WorkoutListView: View {
    @State private var workouts: [Workout] = []
    @State private var showingNewWorkoutForm = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    WorkoutItem(workout: workout)
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
                NewWorkoutForm(workouts: $workouts)
            }
        }
    }
    
    private func deleteWorkouts(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }
    
}

#Preview {
    WorkoutListView()
}
