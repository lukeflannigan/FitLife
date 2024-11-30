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
    let userGoals: [UserGoals]
    var userGoal: UserGoals? { userGoals.first }

    // Access sorted body weight entries
    var bodyWeightEntries: [BodyWeightEntry] {
        (userGoal?.bodyMetrics.bodyWeightLog ?? []).sorted { $0.date > $1.date } // Descending order
    }

    @State private var isAddingWeight = false

    var body: some View {
        ScrollView { // Make the entire content scrollable
            VStack(spacing: 20) {
                // Chart View
                VStack(alignment: .leading, spacing: 16) {
                    WeightChartView(userGoals: userGoals)
                }
                .padding(.horizontal)

                // Entries List
                LazyVStack(spacing: 16) {
                    if bodyWeightEntries.isEmpty {
                        EmptyStateView()
                            .padding(.top, 20)
                    } else {
                        ForEach(bodyWeightEntries) { entry in
                            SwipeToDeleteWeightCard(
                                entry: entry,
                                isMetric: userGoal?.isMetric ?? true,
                                deleteAction: { deleteWeightEntry(entry) }
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isAddingWeight) {
            AddWeightEntryView(userGoal: userGoal)
        }
    }

    private func deleteWeightEntry(_ entry: BodyWeightEntry) {
        if let index = userGoal?.bodyMetrics.bodyWeightLog.firstIndex(where: { $0.id == entry.id }) {
            userGoal?.bodyMetrics.bodyWeightLog.remove(at: index)
            modelContext.delete(entry)
            do {
                try modelContext.save()
            } catch {
                print("Error deleting weight entry: \(error)")
            }
        }
    }
}

// MARK: - Swipe to Delete Weight Card
struct SwipeToDeleteWeightCard: View {
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    let entry: BodyWeightEntry
    let isMetric: Bool
    let deleteAction: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            // Background for the swipe action
            Color.red
                .overlay(
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding(.trailing, 20),
                    alignment: .trailing
                )
                .frame(height: 80)

            // Main card content
            BodyWeightCard(entry: entry, isMetric: isMetric)
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 0 { // Only allow left swipe
                                isSwiping = true
                                offset = gesture.translation.width
                            }
                        }
                        .onEnded { _ in
                            if offset < -50 { // Threshold for deletion
                                withAnimation {
                                    deleteAction()
                                }
                            }
                            withAnimation {
                                offset = 0
                                isSwiping = false
                            }
                        }
                )
                .animation(.default, value: offset)
        }
        .clipped()
        .cornerRadius(16)

    }
}

// MARK: - Body Weight Card
struct BodyWeightCard: View {
    let entry: BodyWeightEntry
    let isMetric: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Display weight in the appropriate unit
            Text("\(isMetric ? entry.weight : entry.weight * 2.20462, specifier: "%.1f") \(isMetric ? "kg" : "lbs")")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

