//
//  WorkoutView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/1/24.
//

import SwiftUI
import SwiftData

// MARK: - WorkoutCardView
struct WorkoutCardView: View {
    var workout: Workout
    
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
            // Title
            HStack{
                Text(workout.exercise.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()

                Button(action: {
                    workout.isFavorite.toggle()
                }) {
                    Image(systemName: workout.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                
                Text(workout.exercise.difficulty.rawValue)
                    .padding(10)
                    .foregroundStyle(.white)
                    .font(.system(size: 12))
                    .background(difficultyColor(for: workout.exercise.difficulty), in: Capsule())
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
        VStack(spacing: 30) {
            HStack {
                Text(workout.exercise.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    workout.isFavorite.toggle()
                }) {
                    Image(systemName: workout.isFavorite ? "heart.fill" : "heart")
                        .font(.title)
                        .foregroundColor(workout.isFavorite ? .red : .gray)
                }
            }

            .padding(.top)

            Spacer()

            HStack(spacing: 20) {
                DetailStatView(title: "Sets", value: "\(workout.sets)")
                DetailStatView(title: "Reps", value: "\(workout.reps)")
                DetailStatView(title: "Weight", value: "\(String(format: "%.1f", workout.weight)) lbs")
            }
            .padding(.horizontal)

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
    @State private var inputSetCount: Int = 0
    @State private var inputRepCount: Int = 0
    @State private var inputWeight: Double = 0.0
    @State private var showingDifficultyInfoSheet = false
    @State private var inputIsFavorite: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input Exercise")) {
                    TextField("Exercise Name", text: $currExercise.name)
                }
                Section(header: Text("Details")) {
                    // sets
                    Stepper(value: $inputSetCount, in: 0...10) {
                        HStack {
                            Text("Sets")
                            Spacer()
                            Text("\(inputSetCount)")
                        }
                    }
                    // reps
                    Stepper(value: $inputRepCount, in: 0...50) {
                        HStack {
                            Text("Reps")
                            Spacer()
                            Text("\(inputRepCount)")
                        }
                    }
                    // weight
                    Stepper(value: $inputWeight, in: 0...500, step: 2.5) {
                        HStack {
                            Text("Weight (lbs)")
                            Spacer()
                            Text("\(String(format: "%.1f", inputWeight))")
                        }
                    }
                }
                // difficulty
                Section(header: Text("Difficulty")) {
                    Picker("Difficulty", selection: $currExercise.difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }
                    }
                    .pickerStyle(.segmented)
                    Text("What should I pick? >")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showingDifficultyInfoSheet = true
                        }
                        .sheet(isPresented: $showingDifficultyInfoSheet) {
                            DifficultyInfoView()
                        }
                }
                // favorite
                Section(header: Text("Favorite")) {
                    Toggle("Mark as Favorite", isOn: $inputIsFavorite)
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
                        let newWorkout = Workout(
                            exercise: currExercise,
                            sets: inputSetCount,
                            reps: inputRepCount,
                            weight: inputWeight,
                            isFavorite: inputIsFavorite
                        )
                        workouts.append(newWorkout)
                        presentationMode.wrappedValue.dismiss()
                    }
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
    @State private var workouts: [Workout] = []
    @State private var showingNewWorkoutForm = false
    @State private var searchText: String = ""
    @Environment(\.modelContext) private var modelContext

    enum WorkoutFilter {
        case all, favorites
    }

    @State private var selectedFilter: WorkoutFilter = .all

    var filteredWorkouts: [Workout] {
        let searchFiltered = workouts.filter { workout in
            searchText.isEmpty || workout.exercise.name.localizedCaseInsensitiveContains(searchText)
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

                if !filteredWorkouts.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredWorkouts) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    WorkoutCardView(workout: workout)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
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
                    Text("No workouts found.")
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


