// ProgressView.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    @Environment(\.calendar) var calendar
    
    private var workoutDates: Set<Date> {
        Set(workouts.filter { $0.completed }.map { calendar.startOfDay(for: $0.date) })
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                statsRow
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
                .font(.custom("Poppins-SemiBold", size: 18))
                .padding(.horizontal, 4)
            
            contributionGrid
        }
    }
    
    private var contributionGrid: some View {
        let weeks = 12
        let cellSize: CGFloat = 12
        let spacing: CGFloat = 4
        
        return VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: weeks), spacing: spacing) {
                ForEach(0..<7) { row in
                    ForEach(0..<weeks) { col in
                        if let date = dateFor(row: row, col: col, totalWeeks: weeks) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(colorForDate(date))
                                .frame(width: cellSize, height: cellSize)
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
    
    private func colorForDate(_ date: Date) -> Color {
        if workoutDates.contains(calendar.startOfDay(for: date)) {
            return .black
        }
        return Color(.systemGray5)
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
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
