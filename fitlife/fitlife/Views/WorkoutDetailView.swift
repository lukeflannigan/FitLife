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
    let workout: Workout
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(workout.name)
                Text(workout.date.formatted(date: .complete, time: .shortened))
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
