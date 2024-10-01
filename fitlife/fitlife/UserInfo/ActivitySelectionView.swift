//
//  ActivitySelectionView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/30/24.
//

import SwiftUI
import SwiftData

struct ActivitySelectionView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var userGoals: UserGoals
    
    // Tracks the selected activity level
    @State private var selectedActivityLevel: ActivityLevel? = nil
    
    // Use all the cases from the ActivityLevel enum
    let activityLevelOptions: [ActivityLevel] = [
        .sedentary,
        .lightActivity,
        .moderateActivity,
        .veryActive,
        .superActive
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                // Title
                Text("Select your activity level, \(userGoals.name)")
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
                
                // Subtitle
                Text("We use this info to tailor your activity plan")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Displaying all the activity level options
                List {
                    ForEach(activityLevelOptions, id: \.self) { level in
                        Button(action: {
                            // Set the selected activity level
                            selectedActivityLevel = level
                        }) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(level.rawValue)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(selectedActivityLevel == level ? Color.white : Color.black)
                                
                                // Add descriptions for each activity level
                                Text(description(for: level))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(selectedActivityLevel == level ? Color.black : Color(.systemGray5))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                NavigationLink(destination: GetAgeGenderView(userGoals: $userGoals)) {
                    Text("Next")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(selectedActivityLevel == nil) // Disable if no selection
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 30)
                .onTapGesture {
                    // Save the selected activity level to the userGoals model
                    if let selectedLevel = selectedActivityLevel {
                        userGoals.activityLevel = selectedLevel
                        // modelContext.save() or any other necessary action
                    }
                }
            }
            .navigationTitle("Activity Level")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Helper function to provide descriptions for each activity level
    private func description(for level: ActivityLevel) -> String {
        switch level {
        case .sedentary:
            return "Spend most of the day sitting (e.g., bank teller, desk job)"
        case .lightActivity:
            return "Spend a good part of the day on your feet (e.g., teacher, salesperson)"
        case .moderateActivity:
            return "Spend a good part of the day doing some physical activity (e.g., food server, postal carrier)"
        case .veryActive:
            return "Spend most of the day doing heavy physical activity (e.g., bike messenger, carpenter)"
        case .superActive:
            return "Spend most of the day doing intense physical activity (e.g., manual labor, professional athlete)"
        }
    }
}

#Preview {
    ActivitySelectionView(userGoals: .constant(UserGoals.mockUserGoals))
}
