
import SwiftUI
import Foundation

// The RecipeObject: i.e All Relevant Recipe Information.
struct RecipeObject: Hashable, Codable{
    let label: String
    let image: String
    let url: String
    let shareAs: String
    let ingredientLines: [String]
    let yield: Double
    let calories: Double
    let totalNutrients: TotalNutrients
    
    // Nested struct for nutrients
    struct TotalNutrients: Codable, Hashable {
        let FAT: Nutrient
        let CHOCDF: Nutrient
        let FIBTG: Nutrient
        let PROCNT: Nutrient
        let SUGAR: Nutrient
        
        struct Nutrient: Codable, Hashable {
            let label: String
            let quantity: Double
            let unit: String
        }
    }
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
        if let path = Bundle.main.path(forResource: "RecipeSearch", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let id = dict["app_id"] as? String,
           let key = dict["app_key"] as? String{
            
            // Ensure the query is URL-safe
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "
            
            // Construct the URL string with credentials
            let urlString = "https://api.edamam.com/api/recipes/v2?q=\(encodedQuery)&app_key=\(key)&_cont=CHcVQBtNNQphDmgVQntAEX4BYUt6AwAPSmBJAmEVY1FzAQYVX3cUC2YWMFJ6BldUFzBECmUaMl1zUAUEQzYRUmMXYAYlARFqX3cWQT1OcV9xBE4%3D&type=any&app_id=\(id)"
            
            
            //Validate the URL.
            guard let url = URL(string: urlString) else {
                print("Error: Invalid Link")  //changed String from from 'URL to 'Link' for improved user comprehension.
                return
            }
            
            //This creates the URL Session Data task.
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


            

struct SearchView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
           
            ZStack {
                    // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                            .ignoresSafeArea() // Make gradient fill the entire screen
                            
            ScrollView {  // Added ScrollView here
                        VStack {
                            // Search bar
                            HStack {
                                    TextField("Search recipes...", text: $searchText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .autocapitalization(.none)
                                        
                                    Button(action: {
                                        if !searchText.isEmpty {
                                            isSearching = true
                                            viewModel.fetchData(query: searchText)
                                        }
                                    }) {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.blue)
                                        }
                                }
                                .padding()
                                    
                            // Results list
                            if isSearching {
                                if viewModel.recipes.isEmpty {
                                            ProgressView()
                                                .padding()
                                        } else {
                                            LazyVStack(spacing: 15) {  // Using LazyVStack for better performance
                                                ForEach(viewModel.recipes, id: \.self) { recipe in
                                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                                        RecipeCard(recipe: recipe)  // Extracted card view
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    } else {
                                        // Initial state
                                        VStack {
                                            Image(systemName: "fork.knife.circle.fill")
                                                .font(.system(size: 64))
                                                .foregroundColor(.black)
                                                .padding()
                                            Text("Search for recipes")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                        }
                                        .padding()
                                    }
                                }
                            }
                            .navigationTitle("Recipe Search")
                        }
                    }
    }
}

// Extracted card view for better organization
struct RecipeCard: View {
    let recipe: RecipeObject
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(recipe.label)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("\(Int(recipe.calories)) calories • \(Int(recipe.yield)) servings")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        
        }
}

// Updated RecipeDetailView with improved scrolling
struct RecipeDetailView: View {
    let recipe: RecipeObject
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {  // Explicit vertical scroll
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.cyan]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                //.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 15) {  // Added consistent spacing
                    AsyncImage(url: URL(string: recipe.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(15)
                    
                    Text("Calories: \(Int(recipe.calories))")
                        .font(.headline)
                    
                    Text("Servings: \(Int(recipe.yield))")
                        .font(.headline)
                    
                    // Macros section
                    Group {
                        Text("Macronutrient Information: ")
                            .font(.headline)
                            .padding(.top, 5)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fat: \(String(format: "%.1f", recipe.totalNutrients.FAT.quantity))\(recipe.totalNutrients.FAT.unit)")
                            Text("Carbs: \(String(format: "%.1f", recipe.totalNutrients.CHOCDF.quantity))\(recipe.totalNutrients.CHOCDF.unit)")
                            Text("Fiber: \(String(format: "%.1f", recipe.totalNutrients.FIBTG.quantity))\(recipe.totalNutrients.FIBTG.unit)")
                            Text("Protein: \(String(format: "%.1f", recipe.totalNutrients.PROCNT.quantity))\(recipe.totalNutrients.PROCNT.unit)")
                            Text("Sugar: \(String(format: "%.1f", recipe.totalNutrients.SUGAR.quantity))\(recipe.totalNutrients.SUGAR.unit)")
                        }
                    }
                    
                    Text("Ingredients:")
                        .font(.title2)
                        .padding(.top, 5)
                    
                    VStack(alignment: .leading, spacing: 8) {  // Better spacing for ingredients
                        ForEach(recipe.ingredientLines, id: \.self) { ingredient in
                            HStack(alignment: .top) {
                                Text("•")
                                    .padding(.trailing, 5)
                                Text(ingredient)
                            }
                        }
                    }
                    
                    // The preview environment in xCode doesn't fully support opening URLs.
                    Link(destination: URL(string: recipe.shareAs)!) {
                        HStack {
                            Image(systemName: "link")
                            Text("View Full Recipe")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle(recipe.label)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SearchView()
}
