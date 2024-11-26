//
//  WorkoutTemplateView.swift
//  fitlife
//

import SwiftUI
import SwiftData

struct WorkoutTemplateView: View {
    @Environment(\.modelContext) var modelContext
    @Query var templates: [WorkoutTemplate] // Fetch existing workout templates
    @State private var newWorkoutClicked: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Workout Templates")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                ScrollView {
                    VStack(spacing: 16) {
                        if !templates.isEmpty {
                            ForEach(templates, id: \.id) { template in
                                TemplateCard(template: template, onUse: {
                                    startNewWorkout(with: template)
                                })
                            }
                        } else {
                            Text("No Templates Found")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }

                Spacer()

                Button(action: { newWorkoutClicked.toggle() }) {
                    Text("Add New Template")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
                .sheet(isPresented: $newWorkoutClicked) {
                    NewWorkoutTemplateSheet()
                        .onDisappear {
                            newWorkoutClicked = false // Reset state when sheet is dismissed
                        }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }

    private func saveNewTemplate(name: String, exercises: [Exercise]) {
        let workoutExercises = exercises.map { exercise in
            WorkoutExercise(exercise: exercise) // Convert Exercise to WorkoutExercise
        }
        
        let newTemplate = WorkoutTemplate(name: name, exercises: workoutExercises)
        do {
            modelContext.insert(newTemplate)
            try modelContext.save()
            print("Template saved successfully: \(newTemplate.name)")
        } catch {
            print("Error saving template: \(error)")
        }
    }

    private func startNewWorkout(with template: WorkoutTemplate) {
        print("Starting new workout with template: \(template.name)")
        print("Exercises: \(template.exercises.map { $0.exercise?.name ?? "Unnamed Exercise" }.joined(separator: ", "))")
        // Navigate to workout session or initialize a new workout
    }
}

struct TemplateCard: View {
    let template: WorkoutTemplate
    let onUse: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(template.name)
                .font(.headline)
                .fontWeight(.bold)

            Text("\(template.exercises.count) exercises")
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Spacer()
                Button(action: onUse) {
                    Text("Use")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct NewWorkoutTemplateSheet: View {
    @Environment(\.dismiss) var dismiss // Allows dismissing the sheet
    @Environment(\.modelContext) var modelContext
    @State private var name: String = ""
    @State private var selectedExercises: [Exercise] = []
    @State private var showExerciseLibrary: Bool = false
    @State private var currWorkout: Workout = Workout(id: UUID(), name: "")

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter workout name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Text("Exercises")
                    .font(.headline)
                    .padding(.top)

                if selectedExercises.isEmpty {
                    Text("No exercises selected")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(selectedExercises, id: \.id) { exercise in
                        Text(exercise.name)
                    }
                }

                Spacer()

                Button(action: { showExerciseLibrary.toggle() }) {
                    Text("Add Exercises")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: saveTemplateAndDismiss) { // Updated action
                    Text("Save Template")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(name.isEmpty) // Allow saving even if no exercises are selected
            }
            .navigationTitle("New Template")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showExerciseLibrary) {
                ExerciseLibraryView(
                    workout: currWorkout
                )
            }
        }
    }

    /// Saves the template and dismisses the sheet
    private func saveTemplateAndDismiss() {
        // Map exercises to WorkoutExercise, handle empty case
        let workoutExercises = selectedExercises.map { exercise in
            WorkoutExercise(exercise: exercise)
        }

        // Create a new WorkoutTemplate
        let newTemplate = WorkoutTemplate(name: name, exercises: workoutExercises)

        // Persist the WorkoutTemplate in the SwiftData context
        do {
            modelContext.insert(newTemplate)
            try modelContext.save()
            print("Workout template saved: \(newTemplate.name)")
            
            // Dismiss the sheet after saving
            dismiss()
        } catch {
            print("Error saving template: \(error)")
            // Optionally, you could display an error alert here
        }
    }

    private func addExercise(_ exercise: Exercise) {
        if !selectedExercises.contains(where: { $0.id == exercise.id }) {
            selectedExercises.append(exercise)
        }
    }
}
