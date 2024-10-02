//  NutritionView.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct NutritionView: View {
    var body: some View {
        VStack {
            Text("Nutrition View")
                .font(.custom("Poppins-Bold", size: 24))
                .padding()
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
