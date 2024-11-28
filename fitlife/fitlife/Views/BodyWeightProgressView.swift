//
//  BodyWeightProgressView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/28/24.
//

import SwiftUI
import SwiftData

struct BodyWeightProgressView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \BodyWeightEntry.date, order: .reverse) var bodyWeightEntries: [BodyWeightEntry]
    
    @State private var isAddingWeight = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Chart View
                WeightChartView()

                // Entries List
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if bodyWeightEntries.isEmpty {
                            EmptyStateView()
                        } else {
                            ForEach(bodyWeightEntries) { entry in
                                BodyWeightCard(entry: entry)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            deleteEntry(entry)
                                        } label: {
                                            Label("Delete Entry", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingWeight = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $isAddingWeight) {
                AddWeightEntryView(userGoal: nil) // Pass appropriate UserGoals if needed
            }
        }
    }

    private func deleteEntry(_ entry: BodyWeightEntry) {
        modelContext.delete(entry)
        try? modelContext.save()
    }
}

// MARK: - Body Weight Card
struct BodyWeightCard: View {
    let entry: BodyWeightEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
                .foregroundColor(.secondary)

            Text("\(entry.weight, specifier: "%.1f") lbs")
                .font(.title2)
                .bold()
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Preview
#Preview {
    BodyWeightProgressView()
        .modelContainer(for: [BodyWeightEntry.self, UserGoals.self])
}
