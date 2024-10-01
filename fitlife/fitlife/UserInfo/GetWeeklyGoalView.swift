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
    
    // Filter weekly goals based on whether the user wants to lose, gain, or maintain weight
    var filteredGoals: [WeeklyGoal] {
        if userGoals.goalWeight < userGoals.currentWeight {
            return [.loseWeightSlow, .loseWeightMedium, .loseWeightFast]
        } else if userGoals.goalWeight > userGoals.currentWeight {
            return [.gainWeightSlow, .gainWeightMedium, .gainWeightFast]
        } else {
            return [.maintainWeight]
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                // Title
                Text("What is your weekly goal, \(userGoals.name)?")
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
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                // Next button
                Button(action: {
                    if let selectedGoal = selectedWeeklyGoal {
                        userGoals.weeklyGoal = selectedGoal
                        // modelContext.save() or navigate to next step
                    }
                }) {
                    Text("Next")
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
        }
    }
}

#Preview {
    GetWeeklyGoalView(userGoals: .constant(UserGoals.mockUserGoals))
}
