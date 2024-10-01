//
//  ContentView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "dumbbell")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to FitLife!")
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
