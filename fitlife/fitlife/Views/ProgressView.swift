// ProgressView.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct ProgressView: View {
    var body: some View {
        VStack {
            Text("Progress View")
                .font(.custom("Poppins-Bold", size: 24))
                .padding()
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
