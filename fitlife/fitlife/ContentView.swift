//
//  ContentView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
}
