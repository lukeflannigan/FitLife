//  NutritionView.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct NutritionView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                caloricIntakeSection
                // Will need to add more here eventually
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 80) // To account for tab bar.
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Nutrition")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(.primary)
                Text("Track your daily intake")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }

    private var caloricIntakeSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Today's Calories")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }

            CaloricIntakeCard(currentCalories: 1200, goalCalories: 2000)
        }
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
