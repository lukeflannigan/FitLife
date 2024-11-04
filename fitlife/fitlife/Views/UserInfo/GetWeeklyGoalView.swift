//
//  GetWeeklyGoalView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/30/24.
//

import SwiftUI
import SwiftData

struct GetWeeklyGoalView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var userGoals: UserGoals
    
    // Tracks the selected weekly goal
    @State private var selectedWeeklyGoal: WeeklyGoal? = nil
    // To dismiss this view and navigate to HomeView permanently
    @Environment(\.dismiss) private var dismiss
    
    // Filter weekly goals based on whether the user wants to lose, gain, or maintain weight
    var filteredGoals: [WeeklyGoal] {
        if userGoals.bodyMetrics.goalWeightInKg < userGoals.bodyMetrics.currentWeightInKg {
            return [.loseWeightSlow, .loseWeightMedium, .loseWeightFast]
        } else if userGoals.bodyMetrics.goalWeightInKg > userGoals.bodyMetrics.currentWeightInKg {
            return [.gainWeightSlow, .gainWeightMedium, .gainWeightFast]
        } else {
            return [.maintainWeight]
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                // Title
                Text("What is your weekly goal, \(userGoals.userProfile.name)?")
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
                
                // Subtitle
                Text("We use this info to set your weekly target.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Displaying filtered weekly goal options
                List {
                    ForEach(filteredGoals, id: \.self) { goal in
                        Button(action: {
                            selectedWeeklyGoal = goal
                        }) {
                            Text(goal.rawValue)
                                .font(.headline)
                                .bold()
                                .foregroundColor(selectedWeeklyGoal == goal ? Color.white : Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(selectedWeeklyGoal == goal ? Color.black : Color(.systemGray5))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                    }
                    Text("How many workouts per week?")
                        .padding(.horizontal)
                        .bold()
                    Stepper(value: $userGoals.workoutGoal, in: 1...7) {
                        Text("\(userGoals.workoutGoal) workout(s)")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                // Finish button
                Button(action: {
                    if let selectedGoal = selectedWeeklyGoal {
                        userGoals.weeklyGoal = selectedGoal
                        userGoals.setMacroGoals()
                        modelContext.insert(userGoals)
                        // Navigate permanently to HomeView
                        navigateToHome()
                    }
                }) {
                    Text("Finish")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(selectedWeeklyGoal == nil) // Disable until a goal is selected
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("Goal")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // Helper function to replace the current view with MainView
    private func navigateToHome() {
        // Replace the view with MainView as a new root
        let mainView = MainView()
            .environment(\.modelContext, modelContext)
        let rootView = UIHostingController(rootView: mainView)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
    }
}

//#Preview {
//    GetWeeklyGoalView(userGoals: .constant(UserGoals.mockUserGoals))
//}
