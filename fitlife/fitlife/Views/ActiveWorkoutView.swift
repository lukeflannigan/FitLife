import SwiftUI

struct WorkoutExercise: Identifiable {
    let id = UUID()
    let name: String
}

struct ActiveWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var workout: Workout
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showingExerciseSelection = false
    @State private var selectedExercises: [WorkoutExercise] = []
    @State private var workoutTitle = ""
    
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
                VStack(spacing: 20) {
                    TextField("Workout Name", text: $workoutTitle)
                        .font(.custom("Poppins-SemiBold", size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    Text(formattedTime)
                        .font(.custom("Poppins-Bold", size: 36))
                        .monospacedDigit()
                        .foregroundColor(.black)
                }
                
                Divider()
                    .padding(.horizontal)
                
                if selectedExercises.isEmpty {
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
                            ForEach(selectedExercises) { exercise in
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(exercise.name)
                                        .font(.custom("Poppins-Medium", size: 17))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 16)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                            }
                        }
                    }
                    .padding(.vertical, 8)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Finish") { 
                        timer?.invalidate()
                        dismiss()
                    }
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showingExerciseSelection) {
            ExerciseSelectionSheet(selectedExercises: $selectedExercises)
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
    @Binding var selectedExercises: [WorkoutExercise]
    
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
                            selectedExercises.append(WorkoutExercise(name: exercise))
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

#Preview {
    ActiveWorkoutView(workout: Workout.mockWorkoutEntry)
} 
