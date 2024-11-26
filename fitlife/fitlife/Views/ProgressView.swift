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
        
        return todaysIntake.reduce((calories: 0.0, protein: 0.0, carbs: 0.0, fats: 0.0)) { result, intake in
            (
                calories: result.calories + intake.calories,
                protein: result.protein + intake.protein,
                carbs: result.carbs + intake.carbs,
                fats: result.fats + intake.fats
            )
        }
    }
    
    private let calorieGoal: Double = 2000
    private let proteinGoal: Double = 150
    private let carbsGoal: Double = 250
    private let fatsGoal: Double = 65
    
    private var weeklyWorkoutProgress: Double {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return 0 }
        
        let weekWorkouts = workouts.filter { 
            $0.completed && 
            $0.date >= weekInterval.start && 
            $0.date < weekInterval.end 
        }.count
        
        return Double(weekWorkouts) / Double(weeklyWorkoutGoal)
    }
    
    private let weeklyWorkoutGoal: Int = 5 // Later connect to UserGoals
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                statsRow
                dailyMacrosCard
                activityCard
                weeklyGoalsCard
            }
            .padding(20)
            .padding(.bottom, 80)
        }
        .background(Color(.systemBackground))
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
        .frame(maxWidth: .infinity)
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
                                    .fill(colorForDate(date))
                                    .frame(width: cellSize, height: cellSize)
                            } else {
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func dateFor(row: Int, col: Int, totalWeeks: Int) -> Date? {
        let today = calendar.startOfDay(for: Date())
        
        guard let startOfCurrentWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            return nil
        }
        
        let weeksAgo = totalWeeks - col - 1
        guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: startOfCurrentWeek) else {
            return nil
        }
        
        return calendar.date(byAdding: .day, value: row, to: weekStart)
    }
    
    private func monthAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    private func previousMonths(count: Int) -> [Date] {
        let today = Date()
        return (0..<count).compactMap { months in
            calendar.date(byAdding: .month, value: -months, to: today)
        }.reversed()
    }
    
    private func colorForDate(_ date: Date) -> Color {
        let workoutsOnDate = workouts.filter { 
            $0.completed && calendar.isDate($0.date, inSameDayAs: date)
        }.count
        
        switch workoutsOnDate {
        case 0:
            return Color(.systemGray6)
        case 1:
            return Color(red: 0.4, green: 0.8, blue: 0.4)   
        case 2:
            return Color(red: 0.3, green: 0.7, blue: 0.3) 
        default: // 3 or more
            return Color(red: 0.2, green: 0.6, blue: 0.2) 
        }
    }
    
    private var currentMonthWorkouts: Int {
        workouts.filter {
            $0.completed && calendar.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }.count
    }
    
    private func calculateStreak() -> Int {
        let today = calendar.startOfDay(for: Date())
        var currentDate = today
        var streak = 0
        
        if !workoutDates.contains(today) {
            return 0
        }
        
        while true {
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            
            if !workoutDates.contains(previousDay) {
                break
            }
            
            currentDate = previousDay
            streak += 1
        }
        
        return streak + 1
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
                                    gradient: Gradient(colors: [Color.pink, Color.purple]),
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
                        unit: "g",
                        barColor: Color.blue
                    )
                    
                    MacroBar(
                        value: todaysMacros.carbs,
                        goal: carbsGoal,
                        label: "Carbs",
                        unit: "g",
                        barColor: Color.green
                    )
                    
                    MacroBar(
                        value: todaysMacros.fats,
                        goal: fatsGoal,
                        label: "Fats",
                        unit: "g",
                        barColor: Color.orange
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
    
    private var weeklyGoalsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Goals")
                .font(.system(size: 20, weight: .semibold))
            
            VStack(spacing: 20) {
                GoalProgressRow(
                    icon: "dumbbell.fill",
                    title: "Workout Sessions",
                    progress: weeklyWorkoutProgress,
                    detail: "\(Int(weeklyWorkoutProgress * Double(weeklyWorkoutGoal)))/\(weeklyWorkoutGoal)",
                    progressBarColor: Color.purple
                )
                
                GoalProgressRow(
                    icon: "fork.knife",
                    title: "Calorie Target",
                    progress: min(todaysMacros.calories / calorieGoal, 1.0),
                    detail: "\(Int(todaysMacros.calories))/\(Int(calorieGoal)) kcal",
                    progressBarColor: Color.pink
                )
                
                GoalProgressRow(
                    icon: "chart.bar.fill",
                    title: "Protein Goal",
                    progress: min(todaysMacros.protein / proteinGoal, 1.0),
                    detail: "\(Int(todaysMacros.protein))/\(Int(proteinGoal))g",
                    progressBarColor: Color.blue
                )
            }
        }
        .frame(maxWidth: .infinity)
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
    let barColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray6))
                    .frame(width: 30, height: 100)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(barColor)
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

struct GoalProgressRow: View {
    let icon: String
    let title: String
    let progress: Double
    let detail: String
    let progressBarColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 26, height: 26)
                    .background(progressBarColor)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                    Text(detail)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(progress >= 1.0 ? .green : .primary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray6))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressBarColor)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
