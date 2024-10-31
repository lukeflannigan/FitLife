//  ExerciseLibraryView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI

struct ExerciseLibraryView: View {
    @State private var exercises: [Exercise] = []
    @State private var searchText: String = ""
    @State private var selectedExercise: Exercise?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return exercises
        } else {
            return exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
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



