//  ExerciseLibraryView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI

struct ExerciseLibraryView: View {
    @State private var exercises: [Exercise] = []
    @State private var searchText: String = ""
    @State private var selectedExercise: Exercise?
    @State private var isShowingDetail = false

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

            if !filteredExercises.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredExercises) { exercise in
                            Button(action: {
                                selectedExercise = exercise
                                isShowingDetail = true
                                print("Selected exercise: \(exercise)")
                            }) {
                                ExerciseCardView(exercise: exercise)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal, 20)
            } else {
                Spacer()
                Text("No exercises found.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
        }
        .navigationTitle("Exercise Library")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadExercises()
        }
        .sheet(isPresented: $isShowingDetail) {
            if let exercise = selectedExercise {
                ExerciseDetailView(exercise: exercise)
            }
        }
    }

    // MARK: - Load Exercises
    private func loadExercises() {
        if let url = Bundle.main.url(forResource: "exercises", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedExerciseData = try decoder.decode([ExerciseData].self, from: data)
                exercises = decodedExerciseData.map { $0.toExercise() }
            } catch {
                print("Error loading exercises: \(error)")
            }
        } else {
            print("Could not find exercises.json")
        }
    }
}


