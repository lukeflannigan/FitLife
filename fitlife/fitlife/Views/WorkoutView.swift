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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(workout.exercise.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
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
    var workout: Workout

    var body: some View {
        VStack(spacing: 30) {
            Text(workout.exercise.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            HStack(spacing: 20) {
                DetailStatView(title: "Sets", value: "\(workout.sets)")
                DetailStatView(title: "Reps", value: "\(workout.reps)")
                DetailStatView(title: "Weight", value: "\(String(format: "%.1f", workout.weight)) lbs")
            }
            .padding(.horizontal)

            Spacer()
        }
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
                            weight: inputWeight
                        )
                        workouts.append(newWorkout)
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

    var filteredWorkouts: [Workout] {
        if searchText.isEmpty {
            return workouts
        } else {
            return workouts.filter { $0.exercise.name.localizedCaseInsensitiveContains(searchText) }
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
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal, horizontalPadding)
                } else {
                    Spacer()
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

    private func deleteWorkouts(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }
}

// MARK: - Preview
#Preview {
    WorkoutsView()
}


