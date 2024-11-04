//
//  BodyWeightChartView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/21/24.
//

import SwiftUI

struct BodyWeightChartView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        VStack {
            HStack {
                Text("Start")
                Spacer()
                Text("Current")
                Spacer()
                Text("Goal")
                Spacer()
                Text("Change")
            }
        }
    }
}

#Preview {
    BodyWeightChartView()
}
