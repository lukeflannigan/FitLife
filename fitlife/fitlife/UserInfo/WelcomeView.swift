//
//  WelcomeView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/25/24.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    @Environment(\.modelContext) var modelContext
    @State var userGoals: UserGoals
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("What's your name?")
                    .font(.title2)
                    .bold()
                TextField("Name", text: $userGoals.name)
                Spacer()
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                Button(action: {}) {
//                    Image(systemName: "arrow.2.circlepath.circle")
//                }
//            }
        }
    }
}

//#Preview {
//    WelcomeView(userGoals: .init(name: "gabe", startingWeight: 160, currentWeight: 160, goalWeight: 180, weeklyGoal: WeeklyGoal(rawValue: "loseWeightSlow") ?? <#default value#>, activityLevel: ActivityLevel(rawValue: "active") ?? <#default value#>, baseGoals: []))
//}
