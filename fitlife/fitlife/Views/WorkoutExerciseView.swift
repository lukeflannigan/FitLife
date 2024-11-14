//
//  WorkoutExerciseView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/14/24.
//


//
//  WorkoutExerciseView.swift
//  fitnessapp
//
//  Created by Gabriel Ciaburri on 6/25/24.
//

import SwiftUI

struct WorkoutExerciseView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: Workout
    @State var workoutExercise: WorkoutExercise
    let setNumber = 0

    var body: some View {
            HStack {
                Text(workoutExercise.exercise?.title ?? "Empty")
                Spacer()
                Menu {
                    Button(role: .destructive, action: {
                        deleteWorkoutExercise()
                    }) {
                        Text("Delete")
                            .foregroundStyle(.red)
                    }
                } label: {
                    Label("", systemImage: "ellipsis")
                }
            }
            .padding(.vertical, 1)
            
            HStack {
                Text("Set")
                    .frame(maxWidth: .infinity)
                Text("Previous")
                    .frame(maxWidth: .infinity)
                Text("lbs")
                    .frame(maxWidth: .infinity)
                Text("Reps")
                    .frame(maxWidth: .infinity)
                Image(systemName: "checkmark.rectangle.fill")
                    .frame(maxWidth: .infinity)
            }
        ForEach(Array(workoutExercise.sortedSets.enumerated()), id: \.element.id) { index, set in
            ExerciseSetView(exerciseSet: set, setNumber: index + 1, workoutExercise: $workoutExercise)
            }
                                .listRowSeparator(.hidden)
                Button(action: {workoutExercise.addSet(context: modelContext)}) {
                    Text("Add Set")
                        .frame(maxWidth: .infinity)
                }
                .padding(.top)
                .buttonStyle(.bordered)
    }
    private func deleteWorkoutExercise() {
        workout.removeExercise(workoutExercise, context: modelContext)
        modelContext.delete(workoutExercise)
        do {
            try modelContext.save()
        } catch {
            print("Error deleting workout exercise: \(error)")
        }
    }
}

//#Preview {
//    WorkoutExerciseView()
//}
