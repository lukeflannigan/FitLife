import SwiftUI
import SwiftData

// Track individual set data
struct WorkoutSet: Identifiable {
    let id = UUID()
    var weight: Double
    var reps: Int
    var isCompleted: Bool = false
    
    init(weight: Double = 0, reps: Int = 0) {
        self.weight = weight
        self.reps = reps
    }
}

// Track exercise data during workout
class ActiveExercise: Identifiable, ObservableObject {
    let id = UUID()
    let exercise: Exercise
    @Published var sets: [WorkoutSet]
    
    init(exercise: Exercise) {
        self.exercise = exercise
        // Initialize with one set using exercise's default values
        self.sets = [WorkoutSet(
            weight: exercise.weight,
            reps: exercise.reps
        )]
    }
}

struct ActiveWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var workout: Workout

    @State private var activeExercises: [ActiveExercise] = []
    @State private var workoutTitle = ""
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showingExerciseSelection = false
    @State private var showingCancelAlert = false
    
    private func completeWorkout() {
        // Save workout name and date
        workout.name = workoutTitle.isEmpty ? "Workout \(Date().formatted(date: .abbreviated, time: .shortened))" : workoutTitle
        workout.date = Date()
        
        // Convert ActiveExercises to Exercise models with completed data
        let completedExercises = activeExercises.map { activeExercise -> Exercise in
            return Exercise(
                id: UUID().uuidString,
                name: activeExercise.exercise.name,
                type: activeExercise.exercise.type,
                muscleGroup: activeExercise.exercise.muscleGroup,
                exerciseDescription: activeExercise.exercise.exerciseDescription,
                imageName: activeExercise.exercise.imageName,
                difficulty: activeExercise.exercise.difficulty,
                imageData: activeExercise.exercise.imageData,
                primaryMuscles: activeExercise.exercise.primaryMuscles,
                secondaryMuscles: activeExercise.exercise.secondaryMuscles,
                equipment: activeExercise.exercise.equipment,
                force: activeExercise.exercise.force,
                mechanic: activeExercise.exercise.mechanic,
                sets: activeExercise.sets.count,
                reps: activeExercise.sets.last?.reps ?? 0,
                weight: activeExercise.sets.last?.weight ?? 0
            )
        }
        
        workout.exercises = completedExercises
    }
    
    var formattedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Title and Timer Section
                VStack(spacing: 16) {
                    TextField("Workout Name", text: $workoutTitle)
                        .font(.custom("Poppins-SemiBold", size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                        .submitLabel(.done)
                    
                    VStack(spacing: 4) {
                        Text("Duration")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.secondary)
                        Text(formattedTime)
                            .font(.custom("Poppins-Bold", size: 36))
                            .monospacedDigit()
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 8)
                }
                
                Divider()
                    .padding(.horizontal)
                
                if activeExercises.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No exercises added yet")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(activeExercises) { exercise in
                                ExerciseSetCard(exercise: exercise)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                activeExercises.removeAll { $0.id == exercise.id }
                                            }
                                        } label: {
                                            Label("Delete Exercise", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Add Exercise Button
                Button(action: {
                    showingExerciseSelection = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Exercise")
                            .font(.custom("Poppins-SemiBold", size: 16))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingCancelAlert = true
                    }
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Finish") {
                        completeWorkout()
                        timer?.invalidate()
                        dismiss()
                    }
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.black)
                    .opacity(activeExercises.isEmpty ? 0.5 : 1)
                    .disabled(activeExercises.isEmpty)
                }
            }
        }
        .alert("Cancel Workout?", isPresented: $showingCancelAlert) {
            Button("Cancel Workout", role: .destructive) {
                timer?.invalidate()
                dismiss()
            }
            Button("Continue Workout", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this workout? Your progress will be lost.")
        }
        .sheet(isPresented: $showingExerciseSelection) {
            ExerciseSelectionSheet(selectedExercises: $activeExercises)
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                elapsedTime += 1
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

// Basic exercise selection for now. Will need to connect this to the exercise library to use API. 
struct ExerciseSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedExercises: [ActiveExercise]
    
    let availableExercises = [
        "Barbell Bench Press",
        "Squat",
        "Deadlift"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(availableExercises, id: \.self) { exercise in
                        Button(action: {
                            selectedExercises.append(ActiveExercise(exercise: Exercise(name: exercise)))
                            dismiss()
                        }) {
                            HStack {
                                Text(exercise)
                                    .font(.custom("Poppins-SemiBold", size: 18))
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24))
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.black)
                }
            }
        }
    }
}

struct ExerciseSetCard: View {
    let exercise: ActiveExercise
    @StateObject var activeExercise: ActiveExercise
    
    init(exercise: ActiveExercise) {
        self.exercise = exercise
        _activeExercise = StateObject(wrappedValue: exercise)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(exercise.exercise.name)
                .font(.custom("Poppins-SemiBold", size: 20))
            
            VStack(spacing: 12) {
                ForEach(Array(activeExercise.sets.enumerated()), id: \.element.id) { index, set in
                    HStack(alignment: .center, spacing: 0) {
                        // Set number
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 28, height: 28)
                            Text("\(index + 1)")
                                .font(.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(.white)
                        }
                        .frame(width: 40)
                        
                        // Weight Input
                        HStack(spacing: 4) {
                            TextField("0", text: Binding(
                                get: { String(format: "%.0f", activeExercise.sets[index].weight) },
                                set: { newValue in
                                    if let weight = Double(newValue), weight <= 2000 {
                                        activeExercise.sets[index].weight = weight
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("Poppins-Medium", size: 15))
                            .frame(width: 40)
                            
                            Text("lbs")
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(.systemGray6))
                        )
                        .frame(maxWidth: .infinity)
                        
                        // Multiplication Symbol
                        Text("×")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(.black)
                            .frame(width: 20)
                        
                        // Reps Input
                        HStack(spacing: 4) {
                            TextField("0", text: Binding(
                                get: { String(activeExercise.sets[index].reps) },
                                set: { newValue in
                                    if let reps = Int(newValue), reps <= 100 {
                                        activeExercise.sets[index].reps = reps
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("Poppins-Medium", size: 15))
                            .frame(width: 30)
                            
                            Text("reps")
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(.systemGray6))
                        )
                        .frame(maxWidth: .infinity)
                        
                        // Delete Button
                        Button(action: {
                            if activeExercise.sets.count > 1 {
                                withAnimation {
                                    activeExercise.sets.remove(at: index)
                                }
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red.opacity(0.8))
                                .font(.system(size: 14, weight: .medium))
                        }
                        .frame(width: 40)
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                    activeExercise.sets.append(WorkoutSet())
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 14))
                    Text("Add Set")
                        .font(.custom("Poppins-SemiBold", size: 14))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.black)
                .cornerRadius(8)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 15,
                    x: 0,
                    y: 4
                )
        )
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

#Preview {
    ActiveWorkoutView(workout: Workout.mockWorkoutEntry)
} 
