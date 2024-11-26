// ProgressView.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    @Environment(\.calendar) var calendar
    @Query private var dailyIntakes: [DailyIntake]
    
    private var workoutDates: Set<Date> {
        Set(workouts.filter { $0.completed }.map { calendar.startOfDay(for: $0.date) })
    }
    
    private var todaysMacros: (calories: Double, protein: Double, carbs: Double, fats: Double) {
        let today = calendar.startOfDay(for: Date())
        let todaysIntake = dailyIntakes.filter { calendar.isDate($0.date, inSameDayAs: today) }
        
        return (
            calories: todaysIntake.reduce(0) { $0 + $1.calories },
            protein: todaysIntake.reduce(0) { $0 + $1.protein },
            carbs: todaysIntake.reduce(0) { $0 + $1.carbs },
            fats: todaysIntake.reduce(0) { $0 + $1.fats }
        )
    }
    
    private let calorieGoal: Double = 2000
    private let proteinGoal: Double = 150
    private let carbsGoal: Double = 250
    private let fatsGoal: Double = 65
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                statsRow
                dailyMacrosCard
                activityCard
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var statsRow: some View {
        HStack(spacing: 16) {
            statsCard("Workouts", value: "\(currentMonthWorkouts)", icon: "dumbbell.fill")
            statsCard("Streak", value: "\(calculateStreak())", icon: "flame.fill")
        }
    }
    
    private func statsCard(_ title: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Color.black)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.custom("Poppins-Bold", size: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var activityCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity")
                .font(.system(size: 20, weight: .semibold))
            
            contributionGrid
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
    
    private var contributionGrid: some View {
        let weeks = 12
        let cellSize: CGFloat = 18
        let spacing: CGFloat = 4
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 0) {
                ForEach(previousMonths(count: 3), id: \.self) { date in
                    Text(monthAbbreviation(for: date))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: (cellSize + spacing) * CGFloat(weeks) / 3)
                }
            }
            .padding(.leading, 32)
            
            HStack(spacing: spacing) {
                VStack(alignment: .trailing, spacing: spacing) {
                    ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(height: cellSize)
                    }
                }
                .padding(.trailing, 8)
                
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: weeks), spacing: spacing) {
                    ForEach(0..<7) { row in
                        ForEach(0..<weeks) { col in
                            if let date = dateFor(row: row, col: col, totalWeeks: weeks) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(workoutDates.contains(date) ? Color.black : Color(.systemGray6))
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func dateFor(row: Int, col: Int, totalWeeks: Int) -> Date? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weeksAgo = totalWeeks - col - 1
        let daysAgo = weeksAgo * 7 + row
        return calendar.date(byAdding: .day, value: -daysAgo, to: today)
    }
    
    private func monthAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    private func previousMonths(count: Int) -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<count).compactMap { months in
            calendar.date(byAdding: .month, value: -months, to: today)
        }.reversed()
    }
    
    private func colorForDate(_ date: Date) -> Color {
        workoutDates.contains(date) ? Color.accentColor : Color(.systemGray5)
    }
    
    private var currentMonthWorkouts: Int {
        workouts.filter {
            $0.completed && calendar.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }.count
    }
    
    private func calculateStreak() -> Int {
        var currentDate = calendar.startOfDay(for: Date())
        var streak = 0
        
        while workoutDates.contains(currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
        }
        
        return streak
    }
    
    private var dailyMacrosCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Macros")
                .font(.system(size: 20, weight: .semibold))
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray6), lineWidth: 10)
                            .frame(width: 100, height: 100)
                        
                        Circle()
                            .trim(from: 0, to: min(todaysMacros.calories / calorieGoal, 1.0))
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.black, .gray]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 4) {
                            Text("\(Int(todaysMacros.calories))")
                                .font(.system(size: 24, weight: .bold))
                            Text("kcal")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text("Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 16) {
                    MacroBar(
                        value: todaysMacros.protein,
                        goal: proteinGoal,
                        label: "Protein",
                        unit: "g"
                    )
                    
                    MacroBar(
                        value: todaysMacros.carbs,
                        goal: carbsGoal,
                        label: "Carbs",
                        unit: "g"
                    )
                    
                    MacroBar(
                        value: todaysMacros.fats,
                        goal: fatsGoal,
                        label: "Fats",
                        unit: "g"
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

struct MacroBar: View {
    let value: Double
    let goal: Double
    let label: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray6))
                    .frame(width: 30, height: 100)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.black, .gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 30, height: min(100 * value / goal, 100))
            }
            
            VStack(spacing: 4) {
                Text("\(Int(value))")
                    .font(.system(size: 16, weight: .semibold))
                
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text(unit)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
