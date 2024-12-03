// HomeView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    @Environment(\.calendar) var calendar
    @Query(sort: \DailyNutritionLog.date, order: .reverse) private var dailyLogs: [DailyNutritionLog]

    @Query var userGoals: [UserGoals]
    var userGoal: UserGoals? { userGoals.first }
    
    private var todaysMacros: (calories: Int, protein: Double, carbs: Double, fats: Double) {
        let today = calendar.startOfDay(for: Date())
        guard let todaysLog = dailyLogs.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) else {
            return (calories: 0, protein: 0, carbs: 0, fats: 0)
        }
        
        return (
            calories: todaysLog.totalCalories,
            protein: todaysLog.totalProtein,
            carbs: todaysLog.totalCarbs,
            fats: todaysLog.totalFat
        )
    }
    
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
                    StatCardCalories(
                        title: "Calories",
                        value: "\(todaysMacros.calories) cal",
                        goal: userGoal?.caloriesGoal ?? 2000,
                        color: Color("GradientStart")
                    )
                    StatCard(
                        title: "Protein",
                        value: "\(Int(todaysMacros.protein))g",
                        goal: userGoal?.proteinGoal ?? 150,
                        color: Color("GradientEnd")
                    )
                    StatCard(
                        title: "Carbs",
                        value: "\(Int(todaysMacros.carbs))g",
                        goal: userGoal?.carbsGoal ?? 250,
                        color: Color("GradientStart")
                    )
                    StatCard(
                        title: "Fats",
                        value: "\(Int(todaysMacros.fats))g",
                        goal: userGoal?.fatsGoal ?? 65,
                        color: Color("GradientEnd")
                    )
                }
            }
        }
    
    private var recentActivitySection: some View {
        RecentActivityView()
    }
    
    private var goalProgressSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Goal Progress")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }

            if let workoutGoal = userGoal?.workoutGoal, workoutGoal > 0 {
                // Filter workouts completed within the current week
                let completedWorkouts = workouts.filter { workout in
                    let isCompleted = workout.completed
                    let isInCurrentWeek = isDateInCurrentWeek(workout.date)
                    return isCompleted && isInCurrentWeek
                }.count

                // Avoid division by zero and calculate progress
                let progress = workoutGoal > 0 ? Double(completedWorkouts) / Double(workoutGoal) : 0.75


                GoalProgressView(
                    progress: progress,
                    goal: "Weekly Workout Goal",
                    current: "\(completedWorkouts)",
                    target: "\(workoutGoal)"
                )
            } else {
                Text("No workout goal set.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
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

private func isDateInCurrentWeek(_ date: Date) -> Bool {
    let calendar = Calendar.current

    // Get the start and end of the current week
    guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
        return false
    }

    // Check if the given date is within the week interval
    return weekInterval.contains(date)
}
