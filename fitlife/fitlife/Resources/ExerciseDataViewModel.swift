//
//  ExerciseDataViewModel.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/14/24.
//


import Foundation
import SwiftData
import SwiftUI

@MainActor
class ExerciseDataViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let apiClient = ExerciseAPIClient.shared

    init() {}

    func loadExercises(modelContext: ModelContext) async {
        // Fetch exercises from modelContext first
        let fetchDescriptor = FetchDescriptor<Exercise>()
        let storedExercises = try? modelContext.fetch(fetchDescriptor)
        
        if let storedExercises = storedExercises, !storedExercises.isEmpty {
            exercises = storedExercises
            return
        }
        
        // If no stored exercises, fetch from API
        isLoading = true
        errorMessage = nil
        do {
            let fetchedExercises = try await apiClient.fetchExercises()
            await updateExercises(with: fetchedExercises, modelContext: modelContext)
            isLoading = false
        } catch {
            errorMessage = "Failed to load exercises. Please try again later."
            isLoading = false
        }
    }
    
    private func updateExercises(with newExercises: [Exercise], modelContext: ModelContext) async {
        for newExercise in newExercises {
            if !exercises.contains(where: { $0.id == newExercise.id }) {
                modelContext.insert(newExercise)
                exercises.append(newExercise)
            }
        }
        try? modelContext.save()  // Save the exercises to persistent storage
    }
}
