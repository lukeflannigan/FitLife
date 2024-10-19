//  FoodAPI.swift
//  fitlife
//  Created by Sam Arshad on 10/2/24.


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
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let id = dict["app_id"] as? String,
           let key = dict["app_key"] as? String{
            
            // Ensure the query is URL-safe
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            // Construct the URL string with credentials
            let urlString = "https://api.edamam.com/api/recipes/v2?q=\(encodedQuery)&app_key=\(key)&_cont=CHcVQBtNNQphDmgVQntAEX4BYUt6AwAPSmBJAmEVY1FzAQYVX3cUC2YWMFJ6BldUFzBECmUaMl1zUAUEQzYRUmMXYAYlARFqX3cWQT1OcV9xBE4%3D&type=any&app_id=\(id)"
            
            
            //Validate the URL.
            guard let url = URL(string: urlString) else {
                print("Error: Invalid Link")  //changed String from from 'URL to 'Link' for improved user comprehension.
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Handle errors
                if let error = error {
                    print("\nError: \(error.localizedDescription)\n!")
                    return
                }
                
                // Check for Valid Data
                guard let validData = data else{
                    print("\nError: No data received.\n")
                    return
                }
                
                do{
                    let decodedResponse  = try JSONDecoder().decode(RecipeResponse.self, from: validData)
                    DispatchQueue.main.async{
                        self.recipes = decodedResponse.hits.map { $0.recipe }
                    }
                }catch{
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    
                    // Print out the raw response for debugging purposes
                    //print(String(data: validData, encoding: .utf8) ?? "Unable to convert data to string for debugging.")
                    
                    
                    // Pretty-print JSON for debugging purposes
                    if let jsonObject = try? JSONSerialization.jsonObject(with: validData, options: []),
                       let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                       let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyPrintedString)")
                    }
                    else {
                        print("Unable to format JSON.")
                    }
                    // Print out the raw response in case JSON couldn't be decoded
                    print(String(data: validData, encoding: .utf8) ?? "Unable to convert data to string for debugging.")
                }
            }
            task.resume()
        }
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

#Preview {
    ContentView()
}
