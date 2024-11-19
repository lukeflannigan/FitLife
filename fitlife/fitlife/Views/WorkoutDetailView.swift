//
//  WorkoutDetailView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/13/24.
//

import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var isEditingName = false
    @Bindable var workout: Workout
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    if isEditingName {
                        TextField("Workout Name", text: $workout.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2.bold())
                            .submitLabel(.done)
                            .onSubmit {
                                isEditingName = false
                            }
                    } else {
                        Text(workout.name)
                            .font(.title2.bold())
                    }
                    
                    Button(action: {
                        isEditingName.toggle()
                    }) {
                        Image(systemName: isEditingName ? "checkmark.circle.fill" : "pencil.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 5)
                
                Text(workout.date.formatted(date: .complete, time: .shortened))
                    .foregroundColor(.secondary)
                
                ForEach(workout.workoutExercises, id: \.id) { (workoutExercise: WorkoutExercise) in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(workoutExercise.exercise?.name ?? "Empty")")
                        ForEach(Array(workoutExercise.sortedSets.enumerated()), id: \.element.id) { index, set in
                            HStack {
                                Text("Set \(index + 1) ")
                                    .padding()
                                Text("\(set.weight, specifier: "%.1f")lbs x \(set.reps)")
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    WorkoutDetailView()
//}
