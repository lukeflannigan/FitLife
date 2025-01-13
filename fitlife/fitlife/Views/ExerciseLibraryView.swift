//  ExerciseLibraryView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI
import SwiftData

// Enum for centralizing sheet presentation
enum ActiveSheet: Identifiable {
    case exerciseCreation
    case filter
    case difficultyInfo

    var id: Int { hashValue }
}

struct ExerciseLibraryView: View {
    @Bindable var workout: Workout
    @Environment(\.modelContext) private var modelContext  // Access modelContext in the view
    @Query var exercises: [Exercise]
    @State private var searchText: String = ""
    @State private var selectedExercise: Exercise?
    @State private var selectedCategory: String = "All"
    @State private var activeSheet: ActiveSheet?  // Centralized sheet state

    var categories: [String] {
        var cats = Array(Set(exercises.map { $0.type.capitalized })).sorted()
        cats.insert("All", at: 0)
        return cats
    }
    
    var filteredExercises: [Exercise] {
        let uniqueExercises = Set(exercises) // Removes duplicates based on Exercise model's hashable conformance
        var filtered = Array(uniqueExercises)

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
//                                Button(action: {
//                                    selectedExercise = exercise
//                                }) {
//                                    ExerciseCardView(exercise: exercise)
//                                        .contentShape(Rectangle())
//                                }
                                NavigationLink(destination: ExerciseDetailView(exercise: exercise)){
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    activeSheet = .exerciseCreation
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18))
                        .accessibilityLabel("Add New Exercise")
                }
            }
        }
        .onAppear {
//            fetchExercises()
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .exerciseCreation:
                ExerciseCreationView()
            case .filter:
                Text("Filter Sheet Placeholder") // Placeholder for filter sheet if needed
            case .difficultyInfo:
                DifficultyInfoView()
            }
        }
    }
}

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

struct DifficultyInfoView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView(){
            VStack(alignment: .leading, spacing: 20) {
                Text("Warmup: A light exercise to get you moving.")
                Text("Moderate: A difficult exercise that does not cause significant exhaustion beyond a few minutes.")
                Text("Intense: An exercise that should use most of your physical exertion and should be used sparingly in your workouts.")

                Text("You can also use your heart rate to determine exercise intensity:")
                Text("Moderate: 50%-70% of your maximum heart rate.")
                Text("Intense: 70%-85% of your maximum heart rate.")
                Text("For more information on measuring your heart rate and determining exercise intensity, you can follow expert guidelines on [exercise intensity ratings](https://www.mayoclinic.org/healthy-lifestyle/fitness/in-depth/exercise-intensity/art-20046887).")

                Spacer()
            }
            .padding(25)
            .font(.body)
            .navigationTitle("Choosing Your Difficulty")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct ExerciseCreationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var muscleGroup: String = ""
    @State private var exerciseDescription: String = ""
    @State private var imageName: String = ""
    @State private var difficulty: Difficulty = .easy
    @State private var imageData: Data? = nil
    @State private var primaryMuscles: String = "" // Comma-separated list for simplicity
    @State private var secondaryMuscles: String = "" // Comma-separated list for simplicity
    @State private var equipment: Equipment = .none
    @State private var force: String = ""
    @State private var mechanic: String = ""
    @State private var isFavorite: Bool = false
    @State private var showingDifficultyInfo = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Details")) {
                    TextField("Name", text: $name)
                    TextField("Type", text: $type)
                    TextField("Muscle Group", text: $muscleGroup)
                    TextField("Description", text: $exerciseDescription)
                    TextField("Image Name", text: $imageName)
                }

                Section(header: Text("Difficulty")) {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Button(action: {
                        showingDifficultyInfo = true
                    }) {
                        HStack {
                            Text("Learn about difficulty levels")
                            Spacer()
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.blue)
                    }
                }

                Section(header: Text("Muscles")) {
                    TextField("Primary Muscles (comma-separated)", text: $primaryMuscles)
                    TextField("Secondary Muscles (comma-separated)", text: $secondaryMuscles)
                }

                Section(header: Text("Equipment")) {
                    Picker("Equipment", selection: $equipment) {
                        ForEach(Equipment.allCases, id: \.self) { equipment in
                            Text(equipment.rawValue).tag(equipment)
                        }
                    }
                }

                Section(header: Text("Additional Details")) {
                    TextField("Force", text: $force)
                    TextField("Mechanic", text: $mechanic)
                }

                Section {
                    Toggle("Favorite Exercise", isOn: $isFavorite)
                }
            }
            .sheet(isPresented: $showingDifficultyInfo) {
                DifficultyInfoView()
            }
            .navigationTitle("New Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExercise()
                        dismiss()
                    }
                    .disabled(name.isEmpty || muscleGroup.isEmpty)
                }
            }
        }
    }

    private func saveExercise() {
        do {
            let primaryMuscleList = parseCommaSeparatedList(primaryMuscles)
            let secondaryMuscleList = parseCommaSeparatedList(secondaryMuscles)

            let newExercise = Exercise(
                name: name,
                type: type,
                muscleGroup: muscleGroup,
                exerciseDescription: exerciseDescription,
                imageName: imageName,
                difficulty: difficulty,
                imageData: imageData,
                primaryMuscles: primaryMuscleList,
                secondaryMuscles: secondaryMuscleList,
                equipment: equipment.rawValue,
                force: force.isEmpty ? nil : force,
                mechanic: mechanic.isEmpty ? nil : mechanic,
                isFavorite: isFavorite
            )

            modelContext.insert(newExercise)
            try modelContext.save()
        } catch {
            print("Failed to save exercise: \(error)")
            // You can add user-facing error handling here, such as an alert
        }
    }

    private func parseCommaSeparatedList(_ input: String) -> [String] {
        return input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
