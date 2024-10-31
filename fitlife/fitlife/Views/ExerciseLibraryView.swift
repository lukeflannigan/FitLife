//  ExerciseLibraryView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI

struct ExerciseLibraryView: View {
    @State private var exercises: [Exercise] = []
    @State private var searchText: String = ""
    @State private var selectedExercise: Exercise?
    @State private var isLoading = true
    @State private var errorMessage: String?
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
                exercise.primaryMuscles.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Title
            HStack {
                Text("Exercise Library")
                    .font(.custom("Poppins-Bold", size: 28))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Search Bar
            SearchBar(text: $searchText)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            
            // Category Picker
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
                .padding(.vertical, 8)
            }
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let error = errorMessage {
                Spacer()
                Text(error)
                    .foregroundColor(.red)
                    .padding()
                Spacer()
            } else if filteredExercises.isEmpty {
                Spacer()
                Text("No exercises found.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredExercises) { exercise in
                            Button(action: {
                                selectedExercise = exercise
                            }) {
                                ExerciseCardView(exercise: exercise)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Exercise Library")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadExercises()
        }
        .sheet(item: $selectedExercise) { exercise in
            ExerciseDetailView(exercise: exercise)
        }
    }
    // MARK: - Load Exercises
    private func loadExercises() {
        guard exercises.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                exercises = try await ExerciseAPIClient.shared.fetchExercises()
                isLoading = false
            } catch {
                errorMessage = "Failed to load exercises. Please try again later."
                isLoading = false
            }
        }
    }
}

// MARK: - Supporting Views
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}



