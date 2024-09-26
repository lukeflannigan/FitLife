import SwiftUI
import SwiftData

struct GoalSelectionView: View {
    @Environment(\.modelContext) var modelContext
    @State var userGoals: UserGoals
    
    // Tracks the selected goal
    @State private var selectedGoal: BaseGoal? = nil
    
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
                Text("What are your goals?")
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
                        selectedGoal = goal
                    }) {
                        Text(goal.rawValue)
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedGoal == goal ? Color.black : Color(.systemGray5))
                            .foregroundColor(selectedGoal == goal ? .white : .black)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
                
                // Next button
                Button(action: {
                    // Save selected goal to the userGoals model
                    if let selected = selectedGoal {
                        userGoals.baseGoals = [selected]
                        // modelContext.save() or next action
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
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 30) // Extra padding at the bottom
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalSelectionView(userGoals: UserGoals())
}
