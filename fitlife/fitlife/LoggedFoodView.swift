//
//  LoggedFoodView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/19/24.
//

import SwiftUI
import SwiftData

struct LoggedFoodView: View {
    // Sample data for preview/testing purposes
    @Environment(\.modelContext) var modelContext
    @Query(sort: \DailyIntake.date, order: .reverse) var loggedFood: [DailyIntake]
    var body: some View {
        NavigationView {
            List {
                ForEach(loggedFood) { food in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(food.name)
                            .font(.headline)

                        HStack {
                            Text("Calories: \(Int(food.calories)) kcal")
                            Spacer()
                            Text("Protein: \(food.protein, specifier: "%.1f") g")
                            Spacer()
                            Text("Carbs: \(food.carbs, specifier: "%.1f") g")
                            Spacer()
                            Text("Fats: \(food.fats, specifier: "%.1f") g")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Logged Foods")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddFoodEntryView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
