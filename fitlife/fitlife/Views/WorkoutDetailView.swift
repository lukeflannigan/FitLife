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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Workout Header Card
                VStack(alignment: .leading, spacing: 20) {
                    if isEditingName {
                        VStack(alignment: .leading, spacing: 16) {
                            TextField("Workout Name", text: $tempName)
                                .font(.system(size: 28, weight: .bold))
                                .textFieldStyle(.plain)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    tempName = workout.name
                                    isEditingName = false
                                }) {
                                    Text("Cancel")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
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
                                        .padding(.vertical, 14)
                                        .background(Color.black)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    } else {
                        HStack {
                            Text(workout.name)
                                .font(.system(size: 28, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                tempName = workout.name
                                isEditingName = true
                            }) {
                                Text("Edit")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                        Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.03), radius: 15, x: 0, y: 2)
                
                // Exercises List
                ForEach(workout.workoutExercises, id: \.id) { workoutExercise in
                    VStack(alignment: .leading, spacing: 0) {
                        // Exercise Header
                        HStack(alignment: .top, spacing: 16) {
                            AsyncImage(url: URL(string: workoutExercise.exercise?.imageName ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 65, height: 65)
                            } placeholder: {
                                Color(.systemGray6)
                                    .overlay(
                                        Image(systemName: "dumbbell.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.gray)
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(workoutExercise.exercise?.name ?? "Empty")
                                    .font(.system(size: 20, weight: .semibold))
                                Text(workoutExercise.exercise?.muscleGroup.capitalized ?? "")
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        
                        // Sets List
                        VStack(spacing: 0) {
                            ForEach(Array(workoutExercise.sortedSets.enumerated()), id: \.element.id) { index, set in
                                HStack {
                                    Text("Set \(index + 1)")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Text("\(set.weight, specifier: "%.1f")")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("lbs")
                                            .font(.system(size: 15))
                                            .foregroundColor(.secondary)
                                        
                                        Text("•")
                                            .font(.system(size: 15))
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal, 4)
                                        
                                        Text("\(set.reps)")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("reps")
                                            .font(.system(size: 15))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(index % 2 == 0 ? Color.white : Color(.systemGray6).opacity(0.3))
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.03), radius: 15, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .background(Color(.systemGray6).opacity(0.5))
        .animation(.easeInOut(duration: 0.2), value: isEditingName)
    }
}

//#Preview {
//    WorkoutDetailView()
//}
