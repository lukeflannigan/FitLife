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
    @Query var userGoals: [UserGoals]
    
    // Access sorted body weight entries
    var bodyWeightEntries: [BodyWeightEntry] {
        (userGoals.first?.bodyMetrics.bodyWeightLog ?? []).sorted { $0.date < $1.date }
    }
    
    // Access the goal weight from UserGoals or BodyMetrics
    var goalWeight: Double {
        userGoals.first?.bodyMetrics.goalWeightInPounds() ?? 200
    }
    
    // Calculate the minimum weight in the log
    var minWeight: Double {
        bodyWeightEntries.map { $0.weight }.min() ?? 0
    }
    
    @State private var isAddingWeight = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Weight")
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
                ForEach(bodyWeightEntries) { entry in
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
                    .symbolSize(30)  // Adjust size for better visibility
                    .foregroundStyle(Color.blue)
                }
            }
            .frame(height: 150)
            .chartYScale(domain: minWeight...goalWeight)
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
}
