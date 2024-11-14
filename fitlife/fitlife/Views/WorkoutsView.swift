//
//  WorkoutsView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/1/24.
//

import SwiftUI
import SwiftData
import PhotosUI

// MARK: - CurrentExerciseCardView
struct CurrentExerciseCardView: View {
    var exercise: Exercise

    func difficultyColor(for difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy:
            return Color.green
        case .medium:
            return Color.yellow
        case .hard:
            return Color.red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Exercise Image
            if let imageData = exercise.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
            } else if !exercise.imageName.isEmpty, let uiImage = UIImage(named: exercise.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
            }

            // Exercise Name
            HStack {
                Text(exercise.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer()

                Button(action: {
                    exercise.isFavorite.toggle()
                }) {
                    Image(systemName: exercise.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }

            // Info
            HStack {
                ExerciseInfoCell(title: "Sets", value: "\(exercise.sets)")
                Spacer()
                ExerciseInfoCell(title: "Reps", value: "\(exercise.reps)")
                Spacer()
                ExerciseInfoCell(title: "Weight", value: "\(String(format: "%.1f", exercise.weight)) lbs")
            }

            // Difficulty Indicator
            HStack {
                Text("Difficulty:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(exercise.difficulty.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(difficultyColor(for: exercise.difficulty))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - ExerciseInfoCell
struct ExerciseInfoCell: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - SingleExerciseDetailView
struct SingleExerciseDetailView: View {
    @Bindable var exercise: Exercise

    var body: some View {
        VStack(spacing: 20) {
            // Exercise Image
            if let imageData = exercise.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            } else if !exercise.imageName.isEmpty, let uiImage = UIImage(named: exercise.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
            }

            // Exercise Name
            Text(exercise.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            // Exercise Details
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Type:")
                        .fontWeight(.semibold)
                    Text(exercise.type)
                }

                HStack {
                    Text("Muscle Group:")
                        .fontWeight(.semibold)
                    Text(exercise.muscleGroup)
                }

                HStack {
                    Text("Difficulty:")
                        .fontWeight(.semibold)
                    Text(exercise.difficulty.rawValue.capitalized)
                }

                HStack {
                    Text("Equipment:")
                        .fontWeight(.semibold)
                    Text(exercise.equipment ?? "None")
                }

                Text("Description:")
                    .fontWeight(.semibold)
                Text(exercise.exerciseDescription)
            }
            .padding()

            // Exercise Stats
            HStack(spacing: 20) {
                DetailStatView(title: "Sets", value: "\(exercise.sets)")
                DetailStatView(title: "Reps", value: "\(exercise.reps)")
                DetailStatView(title: "Weight", value: "\(String(format: "%.1f", exercise.weight)) lbs")
            }
            .padding(.top)

            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Exercise Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - DetailStatView
struct DetailStatView: View {
    var title: String
    var value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - ExerciseLibraryRow
struct ExerciseLibraryRow: View {
    var exercise: Exercise
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.action()
        }
    }
}


// MARK: - SearchBar
struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search", text: $text)
                    .foregroundColor(.primary)

                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(8)
            .onTapGesture {
                self.isEditing = true
            }

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    hideKeyboard()
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .padding(.leading, 5)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - WorkoutsView
struct WorkoutsView: View {
    @Bindable var workout: Workout
    @State private var showingNewExerciseForm = false
    @State private var searchText: String = ""
    @State private var showingExerciseLibrary = false
    @State private var showFavoritesOnly: Bool = false // Added for favorites filtering
    @State private var showingActiveWorkout = false  

    // Filtering exercises within the workout based on search text and favorites
    var filteredExercises: [Exercise] {
        var exercises = workout.exercises

        // Apply search filter
        if !searchText.isEmpty {
            exercises = exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        // Apply favorites filter
        if showFavoritesOnly {
            exercises = exercises.filter { $0.isFavorite }
        }

        return exercises
    }

    private let horizontalPadding: CGFloat = 20

    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text(workout.name)
                .font(.custom("Poppins-Bold", size: 28))
                .padding(.top)

            // Search Bar
            SearchBar(text: $searchText)
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 5)

            // Favorites Toggle
            Toggle(isOn: $showFavoritesOnly) {
                Text("Show Favorites Only")
                    .font(.custom("Poppins-Medium", size: 14))
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 5)

            // Browse Exercises Button
            Button(action: {
                showingExerciseLibrary = true
            }) {
                HStack {
                    Image(systemName: "book.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Text("Browse Exercises")
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, horizontalPadding)
            }
            .sheet(isPresented: $showingExerciseLibrary) {
                // Pass the workout to the ExerciseLibraryView
                ExerciseLibraryView(workout: workout)
            }

            if !filteredExercises.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredExercises, id: \.id) { exercise in
                            NavigationLink(destination: SingleExerciseDetailView(exercise: exercise)) {
                                CurrentExerciseCardView(exercise: exercise)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contextMenu {
                                Button {
                                    exercise.isFavorite.toggle()
                                } label: {
                                    Label(exercise.isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: exercise.isFavorite ? "heart.slash" : "heart")
                                }
                                Button(role: .destructive) {
                                    deleteExercise(exercise)
                                } label: {
                                    Label("Delete Exercise", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal, horizontalPadding)
                }
            } else {
                Spacer()
                Text(showFavoritesOnly ? "No favorite exercises found." : "No exercises found.")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Button(action: { showingActiveWorkout = true }) {  // Changed action
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.darkGray))
            }
        )
        .sheet(isPresented: $showingActiveWorkout) {  // Changed sheet presentation
            let newWorkout = Workout(name: "", exercises: [])
            ActiveWorkoutView(workout: newWorkout)
        }
    }

    // MARK: - Delete Exercise Function
    private func deleteExercise(_ exercise: Exercise) {
        if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
            workout.exercises.remove(at: index)
        }
    }
}



// MARK: - NewExerciseForm
struct NewExerciseForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var exercises: [Exercise]
    @State private var currExercise = Exercise()
    @State private var showingDifficultyInfoSheet = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?

    var body: some View {
        NavigationView {
            Form {
                // Exercise Name
                Section(header: Text("Exercise Name")) {
                    TextField("Enter Exercise Name", text: $currExercise.name)
                }

                // Details
                Section(header: Text("Details")) {
                    TextField("Type", text: $currExercise.type)
                    TextField("Muscle Group", text: $currExercise.muscleGroup)
                    TextField("Description", text: $currExercise.exerciseDescription)
                    Stepper(value: $currExercise.sets, in: 0...10) {
                        HStack {
                            Text("Sets")
                            Spacer()
                            Text("\(currExercise.sets)")
                        }
                    }
                    Stepper(value: $currExercise.reps, in: 0...50) {
                        HStack {
                            Text("Reps")
                            Spacer()
                            Text("\(currExercise.reps)")
                        }
                    }
                    Stepper(value: $currExercise.weight, in: 0...500, step: 2.5) {
                        HStack {
                            Text("Weight (lbs)")
                            Spacer()
                            Text("\(String(format: "%.1f", currExercise.weight))")
                        }
                    }
                }

                // Difficulty
                Section(header: DifficultySectionHeader(showingInfoSheet: $showingDifficultyInfoSheet)) {
                    Picker("Difficulty", selection: $currExercise.difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue.capitalized).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .sheet(isPresented: $showingDifficultyInfoSheet) {
                    DifficultyInfoView()
                }

                // Favorite
                Section(header: Text("Favorite")) {
                    Toggle("Mark as Favorite", isOn: $currExercise.isFavorite)
                }

                // Exercise Image
                Section(header: Text("Exercise Image")) {
                    PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
                        Text("Select an Image")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .onChange(of: pickerItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                currExercise.imageData = data // Save the image data in the current exercise
                                if let uiImage = UIImage(data: data) {
                                    selectedImage = Image(uiImage: uiImage) // Display the image
                                }
                            }
                        }
                    }

                    // Display the selected image if available
                    if let selectedImage = selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle("Add Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        exercises.append(currExercise)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(currExercise.name.isEmpty)
                }
            }
        }
    }
}

// Custom section header for difficulty with info button
struct DifficultySectionHeader: View {
    @Binding var showingInfoSheet: Bool

    var body: some View {
        HStack {
            Text("Difficulty")
            Spacer()
            Button(action: {
                showingInfoSheet = true
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle()) // Removes the default button style
        }
    }
}

// MARK: - Difficulty Info Sheet
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

// MARK: - Preview
#Preview {
    WorkoutsView(workout: Workout.mockWorkoutEntry)
}
