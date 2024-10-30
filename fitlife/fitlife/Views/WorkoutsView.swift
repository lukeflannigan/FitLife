//
//  WorkoutsView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/1/24.
//

import SwiftUI
import SwiftData
import PhotosUI

// MARK: - WorkoutCardView
struct WorkoutCardView: View {
    var workout: Workout
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil

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
            // Display images for all exercises
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(workout.exercises, id: \.id) { exercise in
                        if let imageData = exercise.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .cornerRadius(5)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .cornerRadius(5)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }

            // Display names of all exercises
            HStack {
                Text(workout.exercises.map { $0.name }.joined(separator: ", "))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer()

                Button(action: {
                    workout.isFavorite.toggle()
                }) {
                    Image(systemName: workout.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            // Info
            HStack {
                WorkoutInfoCell(title: "Sets", value: "\(workout.sets)")
                Spacer()
                WorkoutInfoCell(title: "Reps", value: "\(workout.reps)")
                Spacer()
                WorkoutInfoCell(title: "Weight", value: "\(String(format: "%.1f", workout.weight)) lbs")
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - WorkoutInfoCell
struct WorkoutInfoCell: View {
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

// MARK: - WorkoutDetailView
struct WorkoutDetailView: View {
    @Bindable var workout: Workout

    var body: some View {
        VStack(spacing: 20) {
            // Display names of all exercises
            Text("Workout Details")
                .font(.largeTitle)
                .fontWeight(.bold)

            ScrollView {
                ForEach(workout.exercises, id: \.id) { exercise in
                    VStack(alignment: .leading, spacing: 10) {
                        // Exercise Image
                        if let imageData = exercise.imageData,
                           let uiImage = UIImage(data: imageData) {
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

                        // Exercise Details
                        Text(exercise.name)
                            .font(.title2)
                            .fontWeight(.bold)

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
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                }

                // Workout Stats
                HStack(spacing: 20) {
                    DetailStatView(title: "Sets", value: "\(workout.sets)")
                    DetailStatView(title: "Reps", value: "\(workout.reps)")
                    DetailStatView(title: "Weight", value: "\(String(format: "%.1f", workout.weight)) lbs")
                }
                .padding(.top)
            }

            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Workout Details")
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

// MARK: - NewWorkoutForm
struct NewWorkoutForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var workouts: [Workout]
    @State private var currExercise = Exercise()
    @State private var selectedExercises: [Exercise] = []
    @State private var inputSetCount: Int = 0
    @State private var inputRepCount: Int = 0
    @State private var inputWeight: Double = 0.0
    @State private var showingDifficultyInfoSheet = false
    @State private var inputIsFavorite: Bool = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?

    var body: some View {
        NavigationView {
            Form {
                // Section to input an exercise name
                Section(header: Text("Input Exercise")) {
                    TextField("Exercise Name", text: $currExercise.name)
                }

                // Section to set workout details
                Section(header: Text("Details")) {
                    Stepper(value: $inputSetCount, in: 0...10) {
                        HStack {
                            Text("Sets")
                            Spacer()
                            Text("\(inputSetCount)")
                        }
                    }
                    Stepper(value: $inputRepCount, in: 0...50) {
                        HStack {
                            Text("Reps")
                            Spacer()
                            Text("\(inputRepCount)")
                        }
                    }
                    Stepper(value: $inputWeight, in: 0...500, step: 2.5) {
                        HStack {
                            Text("Weight (lbs)")
                            Spacer()
                            Text("\(String(format: "%.1f", inputWeight))")
                        }
                    }
                }

                // Section to select difficulty level with Info button in header
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

                // Section to mark as favorite
                Section(header: Text("Favorite")) {
                    Toggle("Mark as Favorite", isOn: $inputIsFavorite)
                }

                // Section for image selection
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
            .navigationBarTitle("Add Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newWorkout = Workout(
                            exercises: selectedExercises,
                            sets: inputSetCount,
                            reps: inputRepCount,
                            weight: inputWeight,
                            isFavorite: inputIsFavorite
                        )
                        workouts.append(newWorkout)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedExercises.isEmpty)
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

// Helper view for multiple selection
struct MultipleSelectionRow: View {
    var exercise: Exercise
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Text(exercise.name)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
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
    var workout: Workout?
    @State private var workouts: [Workout] = Workout.mockWorkoutEntries
    @State private var showingNewWorkoutForm = false
    @State private var searchText: String = ""
    @Environment(\.modelContext) private var modelContext

    enum WorkoutFilter {
        case all, favorites
    }

    @State private var selectedFilter: WorkoutFilter = .all

    var filteredWorkouts: [Workout] {
        let searchFiltered = workouts.filter { workout in
            searchText.isEmpty || workout.exercises.contains(where: { $0.name.localizedCaseInsensitiveContains(searchText) })
        }

        switch selectedFilter {
        case .all:
            return searchFiltered
        case .favorites:
            return searchFiltered.filter { $0.isFavorite }
        }
    }

    private let horizontalPadding: CGFloat = 20

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    // Title
                    Text("My Daily Split")
                        .font(.custom("Poppins-Bold", size: 28))
                        .padding(.top)

                    // Search Bar
                    SearchBar(text: $searchText)
                        .padding(.bottom, 5)

                    // Browse Exercises Button
                    NavigationLink(destination: ExerciseLibraryView()) {
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
                    }
                }
                .padding(.horizontal, horizontalPadding)

                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag(WorkoutFilter.all)
                    Text("Favorites").tag(WorkoutFilter.favorites)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 10)

                if !filteredWorkouts.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredWorkouts) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    WorkoutCardView(workout: workout)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    Button {
                                        workout.isFavorite.toggle()
                                    } label: {
                                        Label(workout.isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: workout.isFavorite ? "heart.slash" : "heart")
                                    }
                                    Button(role: .destructive) {
                                        deleteWorkout(workout)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal, horizontalPadding)
                } else {
                    Spacer()
                    Text(selectedFilter == .favorites ? "No favorite workouts found." : "No workouts found.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button(action: { showingNewWorkoutForm = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.darkGray))
                }
            )
            .sheet(isPresented: $showingNewWorkoutForm) {
                NewWorkoutForm(workouts: $workouts)
            }
        }
    }

    // MARK: - Delete Workout Function

    private func deleteWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
        }
    }
}


// MARK: - Preview
#Preview {
    WorkoutsView()
}


