//
//  WorkoutTemplateView.swift
//  fitlife
//

import SwiftUI
import SwiftData

extension ModelContext {
    func fetchExercise(with uuid: UUID) -> Exercise? {
        let request = FetchDescriptor<Exercise>(predicate: #Predicate { $0.uuid == uuid })
        return try? fetch(request).first
    }
}

struct WorkoutTemplateView: View {
    @Environment(\.modelContext) var modelContext
    @State private var templates: [WorkoutTemplate] = [] // Local array for templates
    @State private var newWorkoutClicked: Bool = false
    @State private var currWorkout: Workout? = nil // Add a state for current workout
    @State private var exercises: Set<UUID> = [] // Add a state for selected exercises
    @State private var isSelectingExercises: Bool = false // Track exercise selection

    var body: some View {
        NavigationView {
            VStack {
                // Title
                Text("Workout Templates")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Templates List
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

                // Add New Template Button
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
                    NewWorkoutTemplateSheet(
                        currWorkout: $currWorkout,
                        onTemplateSaved: { newTemplate in
                            templates.append(newTemplate)
                        },
                        exercises: $exercises
                    )
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .onAppear {
                templates = fetchTemplates()
            }
        }
    }

    private func fetchTemplates() -> [WorkoutTemplate] {
        let descriptor = FetchDescriptor<WorkoutTemplate>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching templates: \(error)")
            return []
        }
    }

    /// Add `saveSelectedExercises` inside `WorkoutTemplateView`
    private func saveSelectedExercises() {
        // Map selected UUIDs to WorkoutExercise objects
        let selectedWorkoutExercises = exercises.compactMap { uuid in
            if let exercise = modelContext.fetchExercise(with: uuid) {
                return WorkoutExercise(exercise: exercise)
            }
            return nil
        }

        // Create a new workout template
        let newTemplate = WorkoutTemplate(name: "New Template", exercises: selectedWorkoutExercises)
        do {
            modelContext.insert(newTemplate)
            try modelContext.save()
            print("Saved new template with \(newTemplate.exercises.count) exercises.")
        } catch {
            print("Error saving template: \(error)")
        }

        // Clear selected exercises after saving
        exercises.removeAll()
    }

    private func startNewWorkout(with template: WorkoutTemplate) {
        print("Starting new workout with template: \(template.name)")
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
    @Binding var currWorkout: Workout?
    var onTemplateSaved: ((WorkoutTemplate) -> Void)? // Callback for parent view
    @Binding var exercises: Set<UUID>

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
                ExerciseSelectionView(
                    selectedExercises: $exercises,
                    currentWorkout: .constant(nil)
                )
            }
        }
    }

    /// Saves the template and dismisses the sheet
    private func saveTemplateAndDismiss() {
        // Map selected exercises (UUIDs) to WorkoutExercise objects
        let selectedWorkoutExercises = exercises.compactMap { uuid in
            if let exercise = modelContext.fetchExercise(with: uuid) {
                return WorkoutExercise(exercise: exercise)
            }
            return nil
        }

        // Create a new WorkoutTemplate with the name and selected exercises
        let newTemplate = WorkoutTemplate(name: name, exercises: selectedWorkoutExercises)

        // Persist the WorkoutTemplate in the model context
        do {
            modelContext.insert(newTemplate)
            try modelContext.save()
            print("Workout template saved: \(newTemplate.name)")
            
            // Notify parent view about the new template
            onTemplateSaved?(newTemplate)
            
            // Dismiss the sheet
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
