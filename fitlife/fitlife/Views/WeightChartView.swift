//
//  BodyWeightChartView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/21/24.
//

import SwiftUI
import Charts
import SwiftData

struct WeightChartView: View {
    let userGoals: [UserGoals]

    // Access sorted body weight entries
    var bodyWeightEntries: [BodyWeightEntry] {
        (userGoals.first?.bodyMetrics.bodyWeightLog ?? []).sorted { $0.date < $1.date }
    }

    // Access goal weight
    var goalWeight: Double {
        let bodyMetrics = userGoals.first?.bodyMetrics
        return isMetric ? (bodyMetrics?.goalWeightInKg ?? 0) : (bodyMetrics?.goalWeightInPounds() ?? 0)
    }

    // Determine units
    var isMetric: Bool {
        userGoals.first?.isMetric ?? true
    }

    // Calculate weights for display
    var displayedEntries: [(date: Date, weight: Double)] {
        bodyWeightEntries.map { entry in
            let weight = isMetric ? entry.weight : entry.weight * 2.20462
            return (date: entry.date, weight: weight)
        }
    }

    @State private var isAddingWeight = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Weight (\(isMetric ? "kg" : "lbs"))")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)

                Spacer()

                Button(action: {
                    isAddingWeight = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }

            Chart {
                ForEach(displayedEntries, id: \.date) { entry in
                    // LineMark for the weight entries
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Weight", entry.weight)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(Color.blue)

                    // PointMark to add a small circle at each entry
                    PointMark(
                        x: .value("Date", entry.date),
                        y: .value("Weight", entry.weight)
                    )
                    .symbolSize(30)
                    .foregroundStyle(Color.blue)
                }
            }
            .frame(height: 150)
            .chartYScale(domain: minWeight...yAxisUpperBound) // Dynamic Y-axis range
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6)))
        .padding(.bottom, 20)
        .sheet(isPresented: $isAddingWeight) {
            AddWeightEntryView(userGoal: userGoals.first)
        }
    }

    // Calculate the minimum and maximum weight for Y-axis range
    private var minWeight: Double {
        displayedEntries.map { $0.weight }.min() ?? 0
    }

    private var maxWeight: Double {
        displayedEntries.map { $0.weight }.max() ?? goalWeight
    }

    private var yAxisUpperBound: Double {
        max(maxWeight, goalWeight)
    }
}
