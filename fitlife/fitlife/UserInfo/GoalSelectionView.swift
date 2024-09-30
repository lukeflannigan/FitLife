import SwiftUI
import SwiftData

struct GoalSelectionView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var userGoals: UserGoals
    
    // Tracks the selected goals
    @State private var selectedGoals: [BaseGoal] = []
    
    // Use all the cases from the BaseGoal enum
    let goalOptions: [BaseGoal] = [
        .weightLoss,
        .weightGain,
        .muscleGain,
        .weightMaintain,
        .modifyDiet,
        .stayHealthy
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                // Title
                Text("What are your goals, \(userGoals.name)?")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                // Subtitle
                Text("We use this info to tailor the app to your preferences")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Displaying all the goal options
                ForEach(goalOptions, id: \.self) { goal in
                    Button(action: {
                        // Toggle selection
                        if selectedGoals.contains(goal) {
                            selectedGoals.removeAll { $0 == goal }
                        } else {
                            selectedGoals.append(goal)
                        }
                    }) {
                        Text(goal.rawValue)
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedGoals.contains(goal) ? Color.black : Color(.systemGray5))
                            .foregroundColor(selectedGoals.contains(goal) ? .white : .black)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
                
                // Next button
                NavigationLink(destination: NutritionGoalSelectionView(userGoals: $userGoals)) {
                    Text("Next")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 30) // Extra padding at the bottom
                .onTapGesture {
                    // Save selected goals to the userGoals model before navigating
                    if !selectedGoals.isEmpty {
                        userGoals.baseGoals = selectedGoals
                        // modelContext.save() or next action
                    }
                }
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalSelectionView(userGoals: .constant(UserGoals.mockUserGoals))

}
