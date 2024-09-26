//
//  WorkoutInputView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/26/24.
//


import SwiftUI

struct Workout: Codable {
    var name: String
    var sets: Int
    var reps: Int
    var weight: Double
}

struct WorkoutInputView: View {
    @State private var workoutName = ""
    @State private var sets = ""
    @State private var reps = ""
    @State private var weight = ""

    // Function to save workout to UserDefaults
    func saveWorkout() {
        // Retrieve any existing workouts from UserDefaults
        var workouts = retrieveWorkouts()
        
        // Create new workout from user input
        guard let setsInt = Int(sets),
              let repsInt = Int(reps),
              let weightDouble = Double(weight) else {
            print("Invalid input")
            return
        }
        
        let newWorkout = Workout(name: workoutName, sets: setsInt, reps: repsInt, weight: weightDouble)
        
        // Add the new workout to the array
        workouts.append(newWorkout)
        
        // Save the updated workout array to UserDefaults
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: "userWorkouts")
        }
    }
    func retrieveWorkouts() -> [Workout] {
        if let savedWorkouts = UserDefaults.standard.object(forKey: "userWorkouts") as? Data {
            if let workouts = try? JSONDecoder().decode([Workout].self, from: savedWorkouts) {
                return workouts
            }
        }
        return []
    }
    
    // VIEW EDITING
    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: ContentView()) {
                Image(systemName: "house")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding() // Optional: adds space between button and screen edge
            
            // Main content for logging workout
            VStack {
                TextField("Workout Name", text: $workoutName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Sets", text: $sets)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    saveWorkout()
                }) {
                    Text("Save Workout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 250)
        }
        .navigationTitle("Log Workout")
        .padding()
    }
}

#Preview {
    WorkoutInputView()
}
