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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Exercise Title and Menu
            HStack(alignment: .center) {
                Text(workoutExercise.exercise?.name ?? "Empty")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
                Menu {
                    Button(role: .destructive, action: {
                        deleteWorkoutExercise()
                    }) {
                        Text("Delete")
                            .foregroundStyle(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            // Column Headers
            HStack(spacing: 0) {
                Spacer().frame(width: 8)
                
                Text("SET")
                    .frame(width: 45, alignment: .center)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                
                Spacer().frame(width: 20)
                
                Text("PREV")
                    .frame(width: 45, alignment: .center)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                
                Spacer().frame(width: 20)
                
                HStack(spacing: 12) {
                    Text("LBS")
                        .frame(width: 70, alignment: .center)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Text("REPS")
                        .frame(width: 70, alignment: .center)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                }
                
                Spacer().frame(width: 16)
                
                Image(systemName: "checkmark")
                    .frame(width: 30)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Spacer().frame(width: 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 8)
            
            // Exercise Sets
            ForEach(Array(workoutExercise.sortedSets.enumerated()), id: \.element.id) { index, set in
                ExerciseSetView(exerciseSet: set, setNumber: index + 1, workoutExercise: $workoutExercise)
            }
            .listRowSeparator(.hidden)
            
            // Add Set Button
            Button(action: { workoutExercise.addSet(context: modelContext) }) {
                Text("Add Set")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
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
