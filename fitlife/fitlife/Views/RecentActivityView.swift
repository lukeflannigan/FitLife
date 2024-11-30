//
//  RecentActivityView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/30/24.
//

import SwiftData
import SwiftUI
import Foundation

struct RecentActivityView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Workout.date, order: .reverse) var recentWorkouts: [Workout]
    @Query(sort: \DailyIntake.date, order: .reverse) var recentFoodEntries: [DailyIntake]
    
    @State private var showAllActivities = false // State to show the popup

    var recentActivities: [Activity] {
        let workouts = recentWorkouts.map { Activity.workout($0) }
        let foodEntries = recentFoodEntries.map { Activity.food($0) }
        
        // Combine and sort by date, limiting to the 3 most recent activities
        return (workouts + foodEntries).sorted { $0.date > $1.date }.prefix(3).map { $0 }
    }
    
    var allActivities: [Activity] {
        let workouts = recentWorkouts.map { Activity.workout($0) }
        let foodEntries = recentFoodEntries.map { Activity.food($0) }
        
        // Combine and sort by date for all activities
        return (workouts + foodEntries).sorted { $0.date > $1.date }
    }

    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Text("Recent Activity")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    showAllActivities = true // Show the popup
                }) {
                    Text("See All")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(Color.blue)
                }
            }

            // Activity Cards
            if recentActivities.isEmpty {
                Text("No recent activity.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(recentActivities) { activity in
                    ActivityRow(icon: activity.icon, title: activity.title, subtitle: activity.subtitle, time: activity.date.formatted(.relative(presentation: .named)))
                }
            }
        }
        .sheet(isPresented: $showAllActivities) {
            AllActivitiesView(allActivities: allActivities)
        }
    }
}

struct AllActivitiesView: View {
    let allActivities: [Activity] // Accept all activities

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(allActivities) { activity in
                        ActivityRow(icon: activity.icon, title: activity.title, subtitle: activity.subtitle, time: activity.date.formatted(.relative(presentation: .named)))
                    }
                }
                .padding()
            }
            .navigationTitle("All Activities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
}
