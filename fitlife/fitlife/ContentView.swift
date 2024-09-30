//
//  ContentView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @State var userGoals = UserGoals()
    
    var body: some View {
        WelcomeView(userGoals: $userGoals)
    }
}

#Preview {
    ContentView()
}
