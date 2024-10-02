// WorkoutsView.swift
// Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct WorkoutsView: View {
    var body: some View {
        VStack {
            Text("Workouts View")
                .font(.custom("Poppins-Bold", size: 24))
                .padding()
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
