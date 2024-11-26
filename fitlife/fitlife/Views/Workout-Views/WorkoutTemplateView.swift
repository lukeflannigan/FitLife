//
//  WorkoutTemplateView.swift
//  fitlife
//

import SwiftUI
import SwiftData

struct WorkoutTemplateView: View {
    @Environment(\.modelContext) var modelContext
    @State private var templates: [WorkoutTemplate] = [] // Local array for templates
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
                    NewWorkoutTemplateSheet(onTemplateSaved: { newTemplate in
                        // Append new template to local array
                        templates.append(newTemplate)
                    })
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .onAppear {
                // Load existing templates into the local array
                templates = fetchTemplates()
            }
        }
    }

    private func fetchTemplates() -> [WorkoutTemplate] {
        // Define a fetch descriptor for WorkoutTemplate
        let descriptor = FetchDescriptor<WorkoutTemplate>()

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching templates: \(error)")
            return []
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
    var onTemplateSaved: ((WorkoutTemplate) -> Void)? // Callback for parent view

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
            
            // Notify parent view about the new template
            onTemplateSaved?(newTemplate)
            
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
