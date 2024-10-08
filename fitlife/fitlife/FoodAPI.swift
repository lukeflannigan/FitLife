//  FoodAPI.swift
//  fitlife
//
//  Created by Sam Arshad on 10/2/24.
//

import SwiftUI
import Foundation

// The RecipeObject
struct RecipeObject: Hashable, Codable{
    let label: String
    let image: String
    let url: String
    let shareAs: String
    let ingredientLines: [String]
    let yield: Double
    let calories: Double
}

// Struct for API Response
struct RecipeResponse: Codable{
    let hits: [Hit]
    
    struct Hit: Codable{
        let recipe: RecipeObject
    }
}

class ViewModel: ObservableObject {
    @Published var recipes: [RecipeObject] = [] // Array to hold fetched recipes
    
        func fetchData(query: String) {
            // Replace with your actual App ID and API Key
//            let appID = Bundle.main.object(forInfoDictionaryKey: "APP_ID") as? String ?? ""
//            let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""

// --------------newest line here----------------------
            let appID = Bundle.main.path(forResource: "Secrets", ofType: "plist")
            
            // Ensure the query is URL-safe
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=\(encodedQuery)&app_id=\(appID)&app_key=\(apiKey)") else {
                return print("Invalid URL")
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data returned from API")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.recipes = decodedResponse.hits.map { $0.recipe } // Map hits to RecipeObject
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    print(String(data: data, encoding: .utf8) ?? "Unable to convert data to string for debugging.")
                }
            }
            task.resume()
    }
}


struct RecipeDetailView: View {
    let recipe: RecipeObject
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                
                Text(recipe.label)
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Calories: \(Int(recipe.calories))")
                    .font(.headline)
                    .padding(.top, 2)
                
                Text("Servings: \(Int(recipe.yield))")
                    .font(.headline)
                    .padding(.top, 2)
                
                Text("Ingredients:")
                    .font(.title2)
                    .padding(.top)
                
                ForEach(recipe.ingredientLines, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                        .padding(.leading)
                        .padding(.top, 1)
                }
                
                Link("View Full Recipe", destination: URL(string: recipe.shareAs)!)
                    .padding(.top)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationTitle(recipe.label)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    ContentView()
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
