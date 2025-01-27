//
//  NutritionGoalSelectionView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/29/24.
//

import SwiftUI
import SwiftData

struct NutritionGoalSelectionView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var userGoals: UserGoals
    
    // Tracks the selected nutrition goals
    @State private var selectedNutritionGoals: [NutritionGoal] = []
    
    // Use all the cases from the NutritionGoal enum
    let nutritionGoalOptions: [NutritionGoal] = [
        .trackMacros,
        .eatVegan,
        .eatVegetarian,
        .eatPescetarian,
        .lessSugar,
        .lessProtein,
        .lessDairy,
        .lessFats,
        .moreProtein,
        .moreDairy,
        .moreFats,
        .moreVeggies,
        .moreFruits
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                // Title
                Text("Select your nutrition goals, \(userGoals.userProfile.name)")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                // Subtitle
                Text("We use this info to tailor your nutrition plan")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Displaying all the nutrition goal options
                List {
                    ForEach(nutritionGoalOptions, id: \.self) { goal in
                        Button(action: {
                            // Toggle selection
                            if selectedNutritionGoals.contains(goal) {
                                selectedNutritionGoals.removeAll { $0 == goal }
                            } else {
                                selectedNutritionGoals.append(goal)
                            }
                        }) {
                            Text(goal.rawValue)
                                .font(.headline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedNutritionGoals.contains(goal) ? Color.black : Color(.systemGray5))
                                .foregroundColor(selectedNutritionGoals.contains(goal) ? .white : .black)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                // Next button
                NavigationLink(destination: ActivitySelectionView(userGoals: $userGoals)) {
                    Text("Next")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(selectedNutritionGoals.isEmpty) // Disable button until goals are selected
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 30) // Extra padding at the bottom
                .onTapGesture {
                    // Save selected nutrition goals to the userGoals model before navigating
                    if !selectedNutritionGoals.isEmpty {
                        userGoals.nutritionGoals = selectedNutritionGoals
                        // Optionally save to modelContext, e.g., modelContext.save()
                    }
                }
            }
            .navigationTitle("Nutrition Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    NutritionGoalSelectionView(userGoals: .constant(UserGoals.mockUserGoals))
//}
