//  ExerciseLibraryView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Bindable var workout: Workout
    @Environment(\.modelContext) private var modelContext  // Access modelContext in the view
    @Query var exercises: [Exercise]
    @State private var searchText: String = ""
    @State private var selectedExercise: Exercise?
    @State private var selectedCategory: String = "All"
    @State private var showingFilterSheet = false
    @State private var showingExerciseCreation = false

    var categories: [String] {
        var cats = Array(Set(exercises.map { $0.type.capitalized })).sorted()
        cats.insert("All", at: 0)
        return cats
    }
    
    var filteredExercises: [Exercise] {
        var uniqueExercises: [String: Exercise] = [:]
        for exercise in exercises {
            if uniqueExercises[exercise.id] == nil {
                uniqueExercises[exercise.id] = exercise
            }
        }
        
        var filtered = Array(uniqueExercises.values)
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.type.capitalized == selectedCategory }
        }
        
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
            
            ZStack {
                if filteredExercises.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No exercises found")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredExercises) { exercise in
                                Button(action: {
                                    selectedExercise = exercise
                                }) {
                                    ExerciseCardView(exercise: exercise)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Exercise Library")
                    .font(.custom("Poppins-SemiBold", size: 18))
            }
            ToolbarItem(placement: .navigationBarTrailing) { // Add the new toolbar item
                    Button(action: {
                        showingExerciseCreation = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                    }
                }
        }
        .onAppear {
//            fetchExercises()
        }
        .sheet(item: $selectedExercise) { exercise in
            NavigationView {
                ExerciseDetailView(exercise: exercise)
            }
        }
        .sheet(isPresented: $showingExerciseCreation) {
            ExerciseCreationView()
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


