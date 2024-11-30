// HomeView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var userGoals: [UserGoals]
    var userGoal: UserGoals? { userGoals.first }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                quickStatsSection
                weightChartSection
                recentActivitySection
                goalProgressSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 80)
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarBackButtonHidden(true)  // Ensure the back button is hidden in HomeView
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.secondary)
                Text("\(userGoal?.userProfile.name ?? "Ted Lehr")")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(.primary)
            }
            .padding(.vertical)
            Spacer()
            Button(action: {
                // Handle notification action
            }) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .padding(12)
                    .background(Color("GradientStart").opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
    
    private var quickStatsSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Today's Overview")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                StatCardCalories(title: "Calories", value: "1,200", goal: userGoal?.caloriesGoal ?? 0, color: Color("GradientStart"))
                StatCard(title: "Protein", value: "75g", goal: userGoal?.proteinGoal ?? 0, color: Color("GradientEnd"))
                StatCard(title: "Carbs", value: "150g", goal: userGoal?.carbsGoal ?? 0, color: Color("GradientStart"))
                StatCard(title: "Fats", value: "40g", goal: userGoal?.fatsGoal ?? 0, color: Color("GradientEnd"))
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Recent Activity")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    // Handle "See all" action
                }) {
                    Text("See All")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(Color("GradientStart"))
                }
            }
            
            VStack(spacing: 10) {
                ActivityRow(icon: "dumbbell.fill", title: "Upper Body Workout", subtitle: "45 minutes • 250 calories", time: "2h ago")
                ActivityRow(icon: "fork.knife", title: "Lunch", subtitle: "Grilled Chicken Salad", time: "5h ago")
            }
        }
    }
    
    private var goalProgressSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Goal Progress")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }

            GoalProgressView(progress: (1 / Double(userGoal?.workoutGoal ?? 0)), goal: "Weekly Workout Goal", current: "4", target: "\(userGoal?.workoutGoal ?? 0)")
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }

    private var weightChartSection: some View {
        NavigationLink(destination: BodyWeightProgressView(userGoals: userGoals)) {
            WeightChartView(userGoals: userGoals)
        }
    }
}


