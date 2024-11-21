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
    @State private var tempName: String = ""
    var workout: Workout
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 20) {
                    if isEditingName {
                        VStack(spacing: 16) {
                            TextField("Workout Name", text: $tempName)
                                .font(.system(size: 24, weight: .bold))
                                .textFieldStyle(.plain)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    tempName = workout.name
                                    isEditingName = false
                                }) {
                                    Text("Cancel")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    workout.name = tempName
                                    try? modelContext.save()
                                    isEditingName = false
                                }) {
                                    Text("Save")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    } else {
                        HStack {
                            Text(workout.name)
                                .font(.system(size: 24, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                tempName = workout.name
                                isEditingName = true
                            }) {
                                Text("Edit")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .foregroundStyle(.black)
                        Text(workout.date.formatted(date: .complete, time: .shortened))
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
                
                ForEach(workout.workoutExercises, id: \.id) { workoutExercise in
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top, spacing: 16) {
                            AsyncImage(url: URL(string: workoutExercise.exercise?.imageName ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Image(systemName: "dumbbell.fill")
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(workoutExercise.exercise?.name ?? "Empty")
                                    .font(.system(size: 20, weight: .semibold))
                                Text(workoutExercise.exercise?.muscleGroup.capitalized ?? "")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        ForEach(Array(workoutExercise.sortedSets.enumerated()), id: \.element.id) { index, set in
                            HStack {
                                Text("Set \(index + 1)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("\(set.weight, specifier: "%.1f") lbs")
                                    .font(.system(size: 16))
                                
                                Text("×")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 8)
                                
                                Text("\(set.reps) reps")
                                    .font(.system(size: 16))
                            }
                            .padding(.vertical, 8)
                            
                            if index < workoutExercise.sortedSets.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    if workoutExercise.id != workout.workoutExercises.last?.id {
                        Divider()
                            .padding(.horizontal, 20)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .animation(.easeInOut(duration: 0.2), value: isEditingName)
    }
}

//#Preview {
//    WorkoutDetailView()
//}
