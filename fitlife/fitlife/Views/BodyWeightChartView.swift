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
        var bodyWeightEntries: [BodyWeightEntry] {
            userGoals.first?.bodyMetrics.bodyWeightLog ?? []
        }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weight")
                .font(.custom("Poppins-SemiBold", size: 18))
                .foregroundColor(.primary)
            
            Chart {
                ForEach(bodyWeightEntries) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Weight", entry.weight)
                    )
                    .foregroundStyle(Color("GradientStart"))
                }
            }
            .frame(height: 150)
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
    }
}
