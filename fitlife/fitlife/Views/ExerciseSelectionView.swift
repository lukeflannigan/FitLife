//
//  ExerciseSelectionView.swift
//  fitnessapp
//
//  Created by Gabriel Ciaburri on 6/20/24.
//

import SwiftUI
import SwiftData

struct ExerciseSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var exercises: [Exercise]
    @Binding var selectedExercises: Set<String>
    @Binding var currentWorkout: Workout?
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    
    var categories: [String] {
        var cats = Array(Set(exercises.map { $0.type.capitalized })).sorted()
        cats.insert("All", at: 0)
        return cats
    }
    
    var filteredExercises: [Exercise] {
        var filtered = exercises
        
        // Apply category filter
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.type.capitalized == selectedCategory }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { exercise in
                exercise.name.localizedCaseInsensitiveContains(searchText) ||
                exercise.primaryMuscles.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                exercise.type.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filter Header
            VStack(spacing: 12) {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryButton(
                                title: category,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            // Exercise List
            List {
                ForEach(filteredExercises) { exercise in
                    ExerciseCardSelectView(exercise: exercise, isSelected: selectedExercises.contains(exercise.id)) {
                        if selectedExercises.contains(exercise.id) {
                            selectedExercises.remove(exercise.id)
                        } else {
                            selectedExercises.insert(exercise.id)
                        }
                    }
                    .listRowBackground(selectedExercises.contains(exercise.id) ? Color.accentColor.opacity(0.1) : nil)
                    .padding(.vertical, 1)
                }
            }
            .listStyle(.plain)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    selectedExercises.removeAll()
                    dismiss()
                }) {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    addSelectedExercisesToWorkout()
                    selectedExercises.removeAll()
                    dismiss()
                }) {
                    Text("Done")
                }
            }
        }
        .navigationTitle("Select Exercises")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addSelectedExercisesToWorkout() {
        let selectedExercisesList = exercises.filter { selectedExercises.contains($0.id) }
        for exercise in selectedExercisesList {
            let workoutExercise = WorkoutExercise(exercise: exercise)
            workoutExercise.addSet(context: modelContext)
            currentWorkout?.workoutExercises.append(workoutExercise)
            modelContext.insert(workoutExercise)
        }
    }
}
