//
//  FoodAPI.swift
//  fitlife
//
//  Created by Sam Arshad on 10/2/24.
//

import SwiftUI

struct RecipeObject: Hashable, Codable{
    
    
}


class ViewModel: ObservableObject {
    
    func fetchData(){
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2") else {
            return print("Invalid URL")
        }
        let task  = URLSession.shared.dataTask(with: url) { data, _,
            error in
            guard let data = data, error == nil else{
                return print("Error")
            }
        }
    }
}

struct Content_View: View {
    var body: some View {
        NavigationView {
            List {
                
            }
        }.navigationTitle("FitLife")
        
    }
}

#Preview {
    ContentView()
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        ContentView()
    }
}
